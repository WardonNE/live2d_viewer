<?php
declare(strict_types=1);
date_default_timezone_set('Asia/Shanghai');
class Publisher 
{
    private $pubspec = 'pubspec.yaml';
    private $arguments;
    private $pubdate;

    private $sftp;
    private $session;

    private $version;
    public function __construct()
    {
        $this->pubdate = date(DATE_RFC1123);
        $this->arguments = getopt('', [
            'name:',
            'job:',
            'skip-clean',
            'version:',

            'imainver',
            'isubver',
            'istagever',
            'ibuildnum',

            'skip-build',

            'host:',
            'port:',
            'username:',
            'pubkey:',
            'prikey:',
            'remote-path:'
        ]);
        $this->validate();
        $this->version = $this->arguments['version'] ?? '';

        $this->checkDartGlobalPackage([
            'flutter_distributor',
        ]);
    }
 
    private function checkDartGlobalPackage(array $packages)
    {
        $checkCommand = 'dart pub global list';
        $outputs = [];
        exec($checkCommand, $outputs);
        foreach($packages as $package) {
            if(!in_array($package, $outputs)) {
                $installCommand = 'dart pub global activate ' . $package;
                $this->execute($installCommand);
            }
        }
    }

    private function validate() : void
    {
        $required = ['host', 'port', 'username', 'pubkey', 'prikey', 'remote-path'];
        if($this->skipBuild()) {
            $required[] = 'version';
        } else {
            $required[] = 'name';
            $required[] = 'job';
        }
        foreach($required as $option) {
            if(empty($this->arguments[$option])) {
                throw new InvalidArgumentException('option `' . $option . '` is required');
            }
        }
    }

    public function run() : void
    {
        if(!$this->skipBuild()) {
            $this->build();
            $this->output('Build completed', true);
        }
        $this->publish();
        $this->output('Published!!');
    }

    private function skipBuild() : bool
    {
        return isset($this->arguments['skip-build']);
    }

    public function restorePubspec() : void
    {
        if(is_file($this->pubspec . '.backup')) {
            unlink($this->pubspec);
            rename($this->pubspec . '.backup', $this->pubspec);
        }
    }

    private function incrementVersion() : void
    {
        $onlineVersion = $this->getOnlineVersion();
        if(!preg_match('/(\d+).(\d+).(\d+)\+(\d+)/', $onlineVersion, $matches)) {
            throw new Exception('invalid version: ' . $onlineVersion);
        }
        list($version, $mainver, $subver, $stagever, $buildnum) = $matches;
        if($this->needIncrementMainVersion()) {
            $mainver++;
            $this->version = "$mainver.0.0+1";
        } elseif($this->needIncrementSubVersion()) {
            $subver++;
            $this->version = "$mainver.$subver.0+1";
        } elseif($this->needIncrementStageVersion()) {
            $stagever++;
            $this->version = "$mainver.$subver.$stagever+1";
        } else {
            $buildnum++;
            $this->version = "$mainver.$subver.$stagever+$buildnum";
        }
        $pattern = '/version:\s((\d+).(\d+).(\d+)\+(\d+))/';
        $pubspec = file_get_contents($this->pubspec);
        if(preg_match($pattern, $pubspec, $matches)) {
            $pubspec = preg_replace($pattern, "version: {$this->version}", $pubspec, 1);
            if(!copy($this->pubspec, $this->pubspec.'.backup')) {
                throw new Exception('can\'t backup pubspec.yaml');
            }
            file_put_contents($this->pubspec, $pubspec);
        } else {
            throw new Exception('can\'t find version number in pubspec.yaml');
        }
    }

    private function needIncrementMainVersion() : bool 
    {
        return isset($this->arguments['imainver']);
    }

    private function needIncrementSubVersion() : bool
    {
        return isset($this->arguments['isubver']);
    }

    private function needIncrementStageVersion() : bool
    {
        return isset($this->arguments['istagever']);
    }

    private function build() : void
    {
        $this->output('Start build application', true);
        $this->output("\tRelease Name: " . $this->arguments['name'], true);
        $this->output("\tRelease Job: {$this->arguments['job']}", true);
        $this->output("\tRelease Skip clean: " . (isset($this->arguments['skip-clean']) ? 'True' : 'False'), true);

        if(!$this->version) {
             // increment version number
            $this->incrementVersion();
        }
        
        try {
            // build
            $releaseCommand = 'flutter_distributor release ';
            $releaseCommand .= "--name {$this->arguments['name']} ";
            $releaseCommand .= "--jobs {$this->arguments['job']} ";
            $releaseCommand .= isset($this->arguments['skip-clean']) ? '--skip-clean' : '';
            $this->execute($releaseCommand);
        } catch(Throwable $e) {
            $this->restorePubspec();
            throw $e;
        }
    }

    private function execute(string $command) : void
    {
        $handle = popen($command, 'r');
        while (!feof($handle)) {
            $line = fgets($handle);
            if($line !== false) {
                $this->output($line);
            }
        }
        pclose($handle);
    }

    private function output(string $message, bool $eol = false) : void
    {
        echo $message, $eol ? PHP_EOL : '';
    }

    private function publish() : void
    {
        if(!$this->version) {
            throw new Exception('need indicate the version number if you just want to publish');
        }
        $package = 'dist' . DIRECTORY_SEPARATOR . $this->version;
        $executable = $package . DIRECTORY_SEPARATOR . 'live2d_viewer-' . $this->version . '-windows.exe';
        $signature = $this->getSignature($executable);
        $this->updateAppcast(basename($executable), $signature);

        {
            $this->output('Start publish application: ' . $package, true);
            $this->output("\tSFTP Host: {$this->arguments['host']}", true);
            $this->output("\tSFTP Port: {$this->arguments['port']}", true);
            $this->output("\tSFTP Username: {$this->arguments['username']}", true);
            $this->output("\tSFTP Public Key: {$this->arguments['pubkey']}", true);
            $this->output("\tSFTP Private Key: {$this->arguments['prikey']}", true);
            $this->output("\tSFTP Remote Path: {$this->arguments['remote-path']}", true);
        }
        
        $this->connect();
        $this->uploadPackage($package);
        $this->uploadAppcast();
        $this->disconnect();
    }

    private function uploadAppcast() : void
    {
        $this->uploadSftp('dist' . DIRECTORY_SEPARATOR . 'appcast.xml', $this->arguments['remote-path'] . '/appcast.xml');
    }

    private function uploadPackage(string $package) : void
    {
        $this->uploadSftp($package, $this->arguments['remote-path'] . '/' . $this->version);
    }

    private function getSignature(string $executable) : string
    {
        $signature = [];
        $this->output('Signation: ' . $executable, true);
        $signatureCommand = 'flutter pub run auto_updater:sign_update ' . $executable;
        // $signatureCommand = '.\windows\flutter\ephemeral\.plugin_symlinks\auto_updater\windows\WinSparkle-0.7.0\bin\sign_update.bat ' . $executable . ' .\dsa_priv.pem';
        if(!exec($signatureCommand, $signature)) {
            throw new Exception('signature failed, command: ' . $signatureCommand);
        }
        return implode('', $signature);
    }

    private function updateAppcast(string $exeName, string $signature) : void
    {
        $xml = '<?xml version="1.0" encoding="UTF-8"?>' . PHP_EOL;
        $xml .= '<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">' . PHP_EOL;
        $xml .= '   <channel>' . PHP_EOL;
        $xml .= '       <title>Live2D Viewer</title>' . PHP_EOL;
        $xml .= '       <description>Live2D Viewer is a windows desktop app to show some live2d model</description>' . PHP_EOL;
        $xml .= '       <language>en</language>' . PHP_EOL;
        $xml .= '       <item>' . PHP_EOL;
        $xml .= "           <title>Version {$this->version}</title>" . PHP_EOL;
        $xml .= "           <pubDate>{$this->pubdate}</pubDate>" . PHP_EOL;
        $xml .= "           <enclosure url='https://appcast.wardonet.cn/live2d-viewer/{$this->version}/$exeName'" . PHP_EOL;
        $xml .= "                    sparkle:dsaSignature='$signature'" . PHP_EOL;
        $xml .= "                    sparkle:version='{$this->version}'" . PHP_EOL;
        $xml .= '                    sparkle:os="windows"' . PHP_EOL;
        $xml .= '                    length="0"' . PHP_EOL;
        $xml .= '                    type="application/octet-stream" />' . PHP_EOL;
        $xml .= '       </item>' . PHP_EOL;
        $xml .= '   </channel>' . PHP_EOL;
        $xml .= '</rss>' . PHP_EOL;
        $this->output('Updating appcast', true);
        file_put_contents('dist' . DIRECTORY_SEPARATOR . 'appcast.xml', $xml);
    }

    private function connect() : void
    {
        $this->output('Connecting: ' . $this->arguments['host'] . ':' . $this->arguments['port'], true);
        $this->session = ssh2_connect($this->arguments['host'], (int) $this->arguments['port']);
        if($this->session === false) {
            throw new Exception('can\'t connect to ' . $this->arguments['host'] . ':' . $this->arguments['port']);
        }
        $this->output('Login authenticating', true);
        if(!ssh2_auth_pubkey_file(
            $this->session, 
            $this->arguments['username'], 
            $this->arguments['pubkey'], 
            $this->arguments['prikey']
        )) {
            throw new Exception('can\'t pass login authentication');
        }
        $this->output('Opening SFTP connection', true);
        $this->sftp = ssh2_sftp($this->session);
        if($this->sftp === false) {
            throw new Exception('can\'t connect sftp');
        }
        $this->output('Opened SFTP connection', true);
    }

    private function disconnect() : void
    {
        ssh2_exec($this->session, 'exit');
        $this->output('Disconneted SFTP', true);
    }

    private function uploadSftp(string $localPath, string $remotePath) : void
    {
        if(is_file($localPath)) {
            $stat = @ssh2_sftp_stat($this->sftp, $remotePath);
            if($stat === false) {
                ssh2_sftp_mkdir($this->sftp, dirname($remotePath), 0777, true);
            }
            $this->output('Uploading: ' . $localPath, true);
            ssh2_scp_send($this->session, $localPath, $remotePath, 0777);
        } else {
            $this->output('Listing: ' . $localPath, true);
            $dirs = scandir($localPath);
            foreach($dirs as $dir) {
                if($dir == '.' || $dir == '..') continue;
                $this->uploadSftp($localPath . DIRECTORY_SEPARATOR . $dir, $remotePath . '/' . $dir);
            }
        }
    }

    private function getOnlineVersion() : string
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'https://appcast.wardonet.cn/live2d-viewer/appcast.xml');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        $response = curl_exec($ch);
        if($response === false) {
            throw new Exception('curl error: ' . curl_error($ch));
        }
        $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if($statusCode !== 200) {
            throw new Exception('http error with code: ' . $statusCode);
        }
        curl_close($ch);
        $document = new DOMDocument();
        $document->loadXML($response);
        $element = $document->getElementsByTagName('enclosure')[0];
        $attributes = $element->attributes;
        $version = '';
        foreach($attributes as $attribute) {
            if($attribute->name === 'version') {
                $version = $attribute->value;
                break;
            }
        }
        return $version;
    }
}

function main() {
    try {
        if (version_compare(PHP_VERSION, '7.4.0', '<')) {
            throw new Exception('php version ^7.4.0 required');
        }
        if(!extension_loaded('ssh2')) {
            throw new Exception('extension `ssh2` not loaded');
        }
        sapi_windows_set_ctrl_handler(function(int $event) {
            if($event === PHP_WINDOWS_EVENT_CTRL_C) {
                throw new Exception('stopped by ctrl+c');
            }
        });
        $publisher = new Publisher();
        $publisher->run();
    } catch(Throwable $e) {
        echo $e->getMessage(), PHP_EOL;
        echo $e->getTraceAsString(), PHP_EOL;
        if(isset($publisher)) {
            $publisher->restorePubspec();
        }
    }
}

main();