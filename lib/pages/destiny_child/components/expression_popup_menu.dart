import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:live2d_viewer/models/destiny_child/character.dart';
import 'package:live2d_viewer/widget/buttons/container_button.dart';
import 'package:live2d_viewer/widget/buttons/image_button.dart';
import 'package:webview_windows/webview_windows.dart';

class ExpressionPopupMenu extends StatefulWidget {
  final List<Expression> expressions;
  final WebviewController webviewController;
  const ExpressionPopupMenu({
    super.key,
    required this.expressions,
    required this.webviewController,
  });

  @override
  State<StatefulWidget> createState() => _ExpressionPopupMenuState();
}

class _ExpressionPopupMenuState extends State<ExpressionPopupMenu> {
  final CustomPopupMenuController menuController = CustomPopupMenuController();
  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      barrierColor: Colors.transparent,
      showArrow: false,
      controller: menuController,
      menuBuilder: () => Container(
        width: 220,
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        decoration: const BoxDecoration(
          color: Color(0xFF4C4C4C),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: widget.expressions
                .map(
                  (item) => ContainerButton(
                    padding: const EdgeInsets.all(5.0),
                    backgroundColor: Colors.transparent,
                    hoverBackgroundColor: Colors.white24,
                    color: Colors.white,
                    onClick: () async {
                      menuController.hideMenu();
                      await widget.webviewController
                          .executeScript('setExpression("${item.name}")');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow_rounded, size: 20),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 9.0),
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        ImageButton(
                          icon: const Icon(Icons.videocam, size: 20),
                          tooltip: 'record expression',
                          onPressed: () async {
                            menuController.hideMenu();
                            await widget.webviewController.executeScript(
                                'snapshotExpression("${item.name}")');
                          },
                        ),
                        Container(width: 10),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      child: const Tooltip(
        message: 'show expressions',
        child: Icon(Icons.face_retouching_natural, size: 20),
      ),
    );
  }
}