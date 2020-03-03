import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';

import 'app_language/select_language_page.dart';
import 'theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final Function changeAppTheme;
  final Function appLanguageChanged;
  final HttpClient httpClient;
  final String currentLanguge;

  const AppDrawer({
    Key key,
    this.changeAppTheme,
    this.appLanguageChanged,
    this.httpClient,
    this.currentLanguge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ExpansionTile(
              leading: Icon(Icons.palette),
              title: Text('Theme'),
              children: <Widget>[
                ListTile(
                    title: Text('Light'),
                    onTap: () {
                      changeAppTheme(AppTheme.Light());
                    }),
                Divider(),
                ListTile(
                    title: Text('Colorful Light'),
                    onTap: () {
                      changeAppTheme(AppTheme.ColorfulLight());
                    }),
                Divider(),
                ListTile(
                    title: Text('Dark'),
                    onTap: () {
                      changeAppTheme(AppTheme.Dark());
                    }),
                Divider(),
                ListTile(
                    title: Text('Colorful Dark'),
                    onTap: () {
                      changeAppTheme(AppTheme.ColorfulDark());
                    }),
                Divider(),
                ListTile(
                    title: Text('Gold Dark'),
                    onTap: () {
                      changeAppTheme(AppTheme.GoldDark());
                    }),
                Divider(),
              ],
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Change Language'),
              onTap: () async {
                String id = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SelectLanguagePage(
                      httpClient: httpClient,
                      currentLanguage: currentLanguge,
                      fromSettings: true,
                    ),
                  ),
                );
                if(appLanguageChanged != null)
                  appLanguageChanged(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
