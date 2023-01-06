import 'dart:convert';
import 'dart:io';

import 'package:live2d_viewer/constants/destiny_child.dart';
import 'package:live2d_viewer/models/destiny_child/character.dart';
import 'package:live2d_viewer/services/backup_service.dart';
import 'package:live2d_viewer/services/destiny_child/destiny_child_service.dart';

class CharacterService extends DestinyChildService {
  final BackupService backupService;
  CharacterService(super.destinyChildSettings)
      : backupService =
            BackupService(destinyChildSettings.characterSettings!.backups!);

  List<Character> load() {
    var items = <Character>[];
    final file = File(destinyChildSettings.characterSettings!.dataPath!);
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      final data = jsonDecode(content);
      for (final item in data) {
        items.add(Character.fromJson(item));
      }
    }
    return items;
  }

  void save(List<Character> data, {bool backupBeforeSave = true}) {
    final dataPath = destinyChildSettings.characterSettings!.dataPath!;
    final file = File(dataPath);
    if (file.existsSync()) {
      if (backupBeforeSave) {
        final dateTime = DateTime.now();
        final backupFile =
            '${file.parent.path}/data.backup.${dateTime.millisecondsSinceEpoch}.json';
        file.copySync(backupFile);
        backupService.add(backupFile);
      }
    } else {
      file.createSync(recursive: true);
    }
    var encoder = const JsonEncoder.withIndent('  ');
    var content = encoder.convert(data);
    file.writeAsStringSync(content);
  }

  void recover() {
    final file = backupService.latestExists;
    if (file != null) {
      file.copySync(destinyChildSettings.characterSettings!.dataPath!);
    }
  }

  static void initViewWindow(Character data, {int? skinIndex}) {
    DestinyChildConstants.characterViewController
        .setData(data, skinIndex: skinIndex);
  }

  static void loadOptions(Skin skin, {required String modelJson}) {
    final content = File(modelJson).readAsStringSync();
    final model = jsonDecode(content);
    skin.expressions = loadExpressions(model);
    skin.motions = loadMotions(model);
  }

  static List<Expression> loadExpressions(Map<String, dynamic> model) {
    final expressions = model['expressions'] as List<dynamic>?;
    return expressions
            ?.map((expression) =>
                Expression(name: expression['name'], file: expression['file']))
            .toList() ??
        [];
  }

  static List<Motion> loadMotions(Map<String, dynamic> model) {
    final motions = model['motions'] as Map<String, dynamic>?;
    final List<Motion> result = [];
    motions?.forEach((name, value) {
      result.add(Motion(name: name));
    });
    return result;
  }
}