import 'package:live2d_viewer/constants/azurlane.dart';
import 'package:live2d_viewer/enum/ship_rarity.dart';
import 'package:live2d_viewer/models/azurlane/models.dart';
import 'package:live2d_viewer/models/base_model.dart';

class CharacterModel extends BaseModel {
  final String code;
  final String name;
  final String avatar;
  final int type;
  final int rarity;
  final int nationality;
  late final List<SkinModel> skins;

  CharacterModel({
    required this.code,
    required this.name,
    required this.avatar,
    required this.type,
    required this.rarity,
    required this.nationality,
  });

  CharacterModel.fromJson(Map<String, dynamic> json)
      : code = json['code'] as String,
        name = json['name'] as String,
        avatar = json['avatar'] as String,
        type = json['type'] as int,
        rarity = json['rarity'] as int,
        nationality = json['nationality'] as int {
    skins = (json['skins'] as List<dynamic>).map((item) {
      return SkinModel.fromJson(item as Map<String, dynamic>)..character = this;
    }).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'avatar': avatar,
      'type': type,
      'rarity': rarity,
      'nationality': nationality,
    };
  }

  String get avatarURL => '${AzurlaneConstants.characterAvatarURL}/$avatar';

  ShipRarity get shipRarity => skins.first.shipRarity;

  int activeSkinIndex = 0;

  SkinModel get activeSkin => skins[activeSkinIndex];

  void switchSkin(SkinModel skin) {
    if (skin != activeSkin) {
      activeSkinIndex = skins.indexOf(skin);
    }
  }

  void reset() {
    activeSkinIndex = 0;
  }
}