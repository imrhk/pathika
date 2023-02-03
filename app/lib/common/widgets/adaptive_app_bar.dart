import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

class AdaptiveScaffold extends StatelessWidget with PlatformWidgetMixin {
  final Widget body;
  final Function? getAppBar;
  final Function? getAppDrawer;
  final Function? getNavigationbar;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.getAppDrawer,
    this.getAppBar,
    this.getNavigationbar,
  });

  @override
  Widget buildAndroid(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: getAppBar?.call(),
      drawer: getAppDrawer?.call(context),
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: getNavigationbar?.call(),
      child: body,
    );
  }
}
