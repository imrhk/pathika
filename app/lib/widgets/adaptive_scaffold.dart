
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

class AdaptiveScaffold extends StatelessWidget with PlatformWidgetMixin {
  final Widget body;
  final PreferredSizeWidget? appbar;
  final Widget? appDrawer;
  final ObstructingPreferredSizeWidget? navigationBar;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appbar,
    this.appDrawer,
    this.navigationBar,
  });

  @override
  Widget buildAndroid(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: appbar,
      drawer: appDrawer,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: navigationBar,
      child: body,
    );
  }
}
