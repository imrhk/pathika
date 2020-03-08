import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/localization/localization_bloc.dart';
import 'package:pathika/places/place_info.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';

import 'app_language/select_language_page.dart';
import 'common/constants.dart';
import 'core/repository.dart';
import 'theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final Function changeAppTheme;
  final Function appLanguageChanged;
  final HttpClient httpClient;
  final String currentLanguge;
  final Function changePlace;

  const AppDrawer({
    Key key,
    this.changeAppTheme,
    this.appLanguageChanged,
    this.httpClient,
    this.currentLanguge,
    this.changePlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpansionTile(
              leading: Icon(Icons.palette),
              title: Text(
                BlocProvider.of<LocalizationBloc>(context)
                    .localize('theme', 'Theme'),
              ),
              children: <Widget>[
                ListTile(
                    title: Text(
                      BlocProvider.of<LocalizationBloc>(context)
                          .localize('light', 'Light'),
                    ),
                    onTap: () {
                      changeAppTheme(AppTheme.Light());
                    }),
                Divider(),
                ListTile(
                    title: Text(
                      BlocProvider.of<LocalizationBloc>(context)
                          .localize('colorful_light', 'Colorful Light'),
                    ),
                    onTap: () {
                      changeAppTheme(AppTheme.ColorfulLight());
                    }),
                Divider(),
                ListTile(
                    title: Text(
                      BlocProvider.of<LocalizationBloc>(context)
                          .localize('dark', 'Dark'),
                    ),
                    onTap: () {
                      changeAppTheme(AppTheme.Dark());
                    }),
                Divider(),
                ListTile(
                    title: Text(
                      BlocProvider.of<LocalizationBloc>(context)
                          .localize('colorful_dark', 'Colorful Dark'),
                    ),
                    onTap: () {
                      changeAppTheme(AppTheme.ColorfulDark());
                    }),
                Divider(),
                ListTile(
                    title: Text(
                      BlocProvider.of<LocalizationBloc>(context)
                          .localize('gold_dark', 'Gold Dark'),
                    ),
                    onTap: () {
                      changeAppTheme(AppTheme.GoldDark());
                    }),
                Divider(),
              ],
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(
                BlocProvider.of<LocalizationBloc>(context)
                    .localize('change_langauge', 'Change Language'),
              ),
              onTap: () async {
                final response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SelectLanguagePage(
                      httpClient: httpClient,
                      currentLanguage: currentLanguge,
                      fromSettings: true,
                    ),
                  ),
                );
                if (appLanguageChanged != null) appLanguageChanged(response);
                Navigator.of(context).pop();
              },
            ),
            PlacesList(
              changePlace: changePlace,
              currentLanguage: currentLanguge,
              httpClient: httpClient,
            )
          ],
        ),
      ),
    );
  }
}

class PlacesList extends StatelessWidget {
  final HttpClient httpClient;
  final String currentLanguage;
  final Function changePlace;

  const PlacesList({
    Key key,
    this.httpClient,
    this.currentLanguage,
    this.changePlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaceInfo>>(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          List<PlaceInfo> places = snapshot.data;
          return ExpansionTile(
              leading: Icon(Icons.history),
              title: Text(
                BlocProvider.of<LocalizationBloc>(context)
                    .localize('archive', 'Archive'),
              ),
              children: places
                  .map(
                    (item) => ListTile(
                      title: Text(item.name),
                      onTap: () {
                        changePlace(item.id);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                  .toList());
        }
        return Container();
      },
      future: getPlaces(),
    );
  }

  Future<List<PlaceInfo>> getPlaces() async {
    String data = await Repository.getResponse(
      httpClient: httpClient,
      url: '$BASE_URL/assets/json/$API_VERSION/places_$currentLanguage.json',
    );
    List<PlaceInfo> places = (json.decode(data) as List)
        .map<PlaceInfo>((item) => PlaceInfo.fromMap(item))
        .toList();
    return places;
  }
}
