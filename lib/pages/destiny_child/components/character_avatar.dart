import 'package:flutter/material.dart';
import 'package:live2d_viewer/components/refreshable_avatar.dart';

class CharacterAvatar extends StatelessWidget {
  final String avatar;
  const CharacterAvatar({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return RefreshableAvatar(path: avatar, width: 100, height: 180);
  }
}
