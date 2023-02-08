import 'package:flutter/cupertino.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

import '../../extensions/context_extensions.dart';
import 'app_settings_widget.dart';

class AppSettingsScreen extends StatelessWidget with PlatformWidgetMixin {
  const AppSettingsScreen({super.key});

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: GestureDetector(
          child: Text(
            context.localize('_settings', 'Settings'),
          ),
        ),
      ),
      child: const AppSettingsWidget(),
    );
  }

  @override
  Widget buildAndroid(BuildContext context) => buildIOS(context);
}
