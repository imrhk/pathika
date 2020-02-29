import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final Function changeAppTheme;

  const AppDrawer({Key key, this.changeAppTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ExpansionTile(
              title: ListTile(
                leading: Icon(Icons.palette),
                title: Text('Theme'),
              ),
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
          ],
        ),
      ),
    );
  }
}
