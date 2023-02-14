import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

class AdaptiveIconButton extends StatelessWidget with PlatformWidgetMixin {
  final Widget icon;
  final Function()? onPressed;

  const AdaptiveIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget buildAndroid(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: icon);
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero, onPressed: onPressed, child: icon);
  }
}
