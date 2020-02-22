import 'package:flutter/material.dart';

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
                      changeAppTheme(
                          appTheme: ThemeData.light().copyWith(
                              primaryColor: Colors.black,
                              accentColor: Colors.lightBlue),
                          useColorsOnCard: false,
                          textColor: null);
                    }),
                Divider(),
                ListTile(
                    title: Text('Colorful Light'),
                    onTap: () {
                      changeAppTheme(
                          appTheme: ThemeData.light().copyWith(
                              primaryColor: Colors.black,
                              accentColor: Colors.pinkAccent),
                          useColorsOnCard: true,
                          textColor: null);
                    }),
                Divider(),
                ListTile(
                    title: Text('Dark'),
                    onTap: () {
                      changeAppTheme(
                          appTheme: ThemeData.dark()
                              .copyWith(primaryColor: Colors.black),
                          useColorsOnCard: false,
                          textColor: null);
                    }),
                Divider(),
                ListTile(
                    title: Text('Colorful Dark'),
                    onTap: () {
                      changeAppTheme(
                          appTheme: ThemeData.dark()
                              .copyWith(primaryColor: Colors.black),
                          useColorsOnCard: true,
                          textColor: null);
                    }),
                Divider(),
                ListTile(
                    title: Text('Gold Dark'),
                    onTap: () {
                      changeAppTheme(
                        appTheme: ThemeData.dark().copyWith(
                          primaryColor: Colors.black,
                          accentColor: Color.fromARGB(255, 255, 215, 0),
                        ),
                        useColorsOnCard: false,
                        textColor: Color.fromARGB(255, 255, 215, 0),
                      );
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
