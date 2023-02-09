import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:live2d_viewer/constants/constants.dart';
import 'package:live2d_viewer/models/nikke/models.dart';
import 'package:live2d_viewer/models/spine_html_data.dart';
import 'package:live2d_viewer/services/services.dart';
import 'package:live2d_viewer/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NikkeService {
  final http = HTTPService();
  final cache = CacheService();

  NikkeService();

  Future<List<CharacterModel>> characters() async {
    final File response = await http.get(NikkeConstants.characterDataURL,
        duration: const Duration(days: 1));
    final List<dynamic> list = jsonDecode(response.readAsStringSync()) as List;
    return list.map((item) {
      return CharacterModel.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<String> loadHtml(ActionModel action) async {
    debugPrint(action.skelURL);
    final resource = await SpineUtil().downloadResource(
      baseURL: action.skin.spineURL,
      imageBaseURL: action.spineURL,
      skeletonURL: action.skelURL,
      atlasURL: action.atlasURL,
    );

    final skelUri = PathUtil().localAssetsUrl(resource['skel'] as String);
    final atlasUri = PathUtil().localAssetsUrl(resource['atlas'] as String);

    final data = SpineHtmlData(
      skelUrl: skelUri.toString(),
      atlasUrl: atlasUri.toString(),
      animation: action.animation,
    );
    final html =
        await rootBundle.loadString(ResourceConstants.spineVersion40Html);
    return WebviewService.renderHtml(html, data);
  }

  saveScreenshot(String data) {
    final path = PathUtil().join([
      NikkeConstants.screenshotPath,
      'images',
      '${DateTime.now().millisecondsSinceEpoch}.jpeg',
    ]);
    FileUtil().write(path, base64Decode(data));
    launchUrlString(path);
  }

  saveVideo(String data) {
    final path = PathUtil().join([
      NikkeConstants.screenshotPath,
      'videos',
      '${DateTime.now().millisecondsSinceEpoch}.webm',
    ]);
    FileUtil().write(path, base64Decode(data));
    launchUrlString(path);
  }
}
