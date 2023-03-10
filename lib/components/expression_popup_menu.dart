import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:live2d_viewer/constants/constants.dart';
import 'package:live2d_viewer/generated/l10n.dart';
import 'package:live2d_viewer/widget/buttons/buttons.dart';
import 'package:webview_windows/webview_windows.dart';

class ExpressionPopupMenu extends StatefulWidget {
  final List<String> expressions;
  final WebviewController webviewController;
  const ExpressionPopupMenu({
    super.key,
    required this.expressions,
    required this.webviewController,
  });

  @override
  State<StatefulWidget> createState() {
    return ExpressionPopupMenuState();
  }
}

class ExpressionPopupMenuState extends State<ExpressionPopupMenu> {
  final CustomPopupMenuController menuController = CustomPopupMenuController();
  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      barrierColor: Colors.transparent,
      showArrow: false,
      controller: menuController,
      menuBuilder: () => Container(
        width: 220,
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
                    backgroundColor: Styles.popupBackgrounColor,
                    hoverBackgroundColor: Styles.hoverBackgroundColor,
                    color: Styles.textColor,
                    hoverColor: Styles.hoverTextColor,
                    onClick: () async {
                      menuController.hideMenu();
                      await widget.webviewController
                          .executeScript('setExpression("$item")');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow_rounded),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 9.0),
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        ImageButton(
                          icon: const Icon(Icons.videocam, size: 20),
                          tooltip: S.of(context).tooltipSnapshotWithExpession,
                          onPressed: () async {
                            menuController.hideMenu();
                            await widget.webviewController
                                .executeScript('snapshotExpression("$item")');
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
      child: Tooltip(
        message: S.of(context).tooltipShowExpressions,
        child: const Icon(Icons.face_retouching_natural, size: 20),
      ),
    );
  }
}
