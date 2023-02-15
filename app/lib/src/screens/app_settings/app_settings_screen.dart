import 'package:flutter/cupertino.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

import '../../routes/routes_extra.dart';
import 'app_settings_page.dart';

class AppSettingsScreen extends StatelessWidget
    with PlatformWidgetMixin, TitledPageMixin {
  const AppSettingsScreen({super.key});

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          pageTitle(context) ?? '',
        ),
        previousPageTitle: previousPageTitle(context),
      ),
      child: const AppSettingsPage(),
    );
  }

  @override
  Widget buildAndroid(BuildContext context) => buildIOS(context);
}
