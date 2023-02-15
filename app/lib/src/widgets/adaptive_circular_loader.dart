import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

class AdaptiveCircularLoader extends StatelessWidget with PlatformWidgetMixin {
  const AdaptiveCircularLoader({super.key});

  @override
  Widget buildAndroid(BuildContext context) {
    return const CircularProgressIndicator();
  }

  @override
  Widget buildIOS(BuildContext context) {
    return const CupertinoActivityIndicator();
  }
}
