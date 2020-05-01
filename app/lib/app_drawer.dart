import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:pathika/common/cupertino_list_tile.dart';
import 'package:pathika/localization/localization_bloc.dart';
import 'package:pathika/places/place_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show HttpClient, Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_language/select_language_page.dart';
import 'common/constants.dart';
import 'core/repository.dart';
import 'theme/app_theme.dart';

class AppSettings extends StatelessWidget {
  final Function changeAppTheme;
  final Function appLanguageChanged;
  final HttpClient httpClient;
  final String currentLanguge;
  final Function changePlace;

  const AppSettings({
    Key key,
    this.changeAppTheme,
    this.appLanguageChanged,
    this.httpClient,
    this.currentLanguge,
    this.changePlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppTheme>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return getSettingsContainer(
            widgets: [
              getSettingsSectionHeader(
                BlocProvider.of<LocalizationBloc>(context).localize('theme', 'Theme'),
              ),
              getRadioGroupWidget(
                  items: LinkedHashMap.from(
                    {
                      BlocProvider.of<LocalizationBloc>(context).localize('light', 'Light'): AppTheme.light(),
                      BlocProvider.of<LocalizationBloc>(context).localize('colorful_light', 'Colorful Light'): AppTheme.colorfulLight(),
                      BlocProvider.of<LocalizationBloc>(context).localize('dark', 'Dark'): AppTheme.dark(),
                      BlocProvider.of<LocalizationBloc>(context).localize('colorful_dark', 'Colorful Dark'): AppTheme.colorfulDark(),
                      BlocProvider.of<LocalizationBloc>(context).localize('gold_dark', 'Gold Dark'): AppTheme.goldDark(),
                    },
                  ),
                  currentSelection: snapshot.data,
                  onSelected: changeAppTheme),
              getSettingsSectionHeader(''),
              getSettingsWidgets(GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        BlocProvider.of<LocalizationBloc>(context).localize('change_langauge', 'Change Language'),
                        style: TextStyle(
                          color: getThemeTextColor(context),
                        ),
                      ),
                    ),
                    Icon(
                      Platform.isIOS ? CupertinoIcons.right_chevron : Icons.keyboard_arrow_right,
                      color: Platform.isIOS ? CupertinoColors.activeBlue : null,
                    ),
                  ],
                ),
                onTap: () async {
                  final response = await Navigator.of(context).push(
                    getPageRoute(
                        builder: (ctx) => getThemeWidget(
                            SelectLanguagePage(
                              httpClient: httpClient,
                              currentLanguage: currentLanguge,
                              fromSettings: true,
                              appTheme: snapshot.data,
                            ),
                            snapshot.data)),
                  );
                  if (appLanguageChanged != null && response != null) {
                    appLanguageChanged(response);
                    Navigator.of(context).pop();
                  } else {
                    if (!Platform.isIOS) Navigator.of(context).pop();
                  }
                },
              )),
              getSettingsSectionHeader(''),
              getSettingsButton(
                text: BlocProvider.of<LocalizationBloc>(context).localize('privacy_policy', 'Privacy Policy'),
                onPress: () {
                  launch(PRIVACY_POLICY_URL);
                },
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: _getCurrentTheme(context),
    );
  }

  Color getThemeTextColor(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoColors.label.resolveFrom(context);
    } else {
      return Theme.of(context).textTheme.bodyText1.color;
    }
  }

  Widget getThemeWidget(Widget child, AppTheme appTheme) {
    if (Platform.isIOS) {
      return CupertinoTheme(data: appTheme.themeDataCupertino, child: child);
    } else {
      return Theme(data: appTheme.themeDataMaterial, child: child);
    }
  }

  Future<AppTheme> _getCurrentTheme(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('APP_THEME')) {
      final appThemeValue = sharedPreferences.getString('APP_THEME');
      return appThemeMap[appThemeValue]();
    }
    return AppTheme.light();
  }

  Widget getSettingsContainer({
    List<Widget> widgets,
  }) {
    if (Platform.isIOS) {
      return CupertinoSettings(items: widgets);
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) => widgets[index],
        itemCount: widgets.length,
      );
    }
  }

  Widget getSettingsSectionHeader(String text) {
    if (Platform.isIOS) {
      return CSHeader(text);
    } else {
      if (text == null || text.isEmpty) return Container();
      return ListTile(
        title: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }

  Widget getRadioGroupWidget<T>({LinkedHashMap<String, T> items, Function onSelected, T currentSelection}) {
    if (Platform.isIOS) {
      return CSSelection<T>(
        items: items.entries.map((entry) => CSSelectionItem<T>(text: entry.key, value: entry.value)).toList(),
        onSelected: (value) => onSelected(value),
        currentSelection: currentSelection,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: items.entries
            .map<Widget>((entry) => RadioListTile(
                  value: entry.value,
                  title: Text(entry.key),
                  groupValue: currentSelection,
                  onChanged: (value) => onSelected(value),
                ))
            .toList(),
      );
    }
  }

  Widget getSettingsWidgets(Widget child) {
    if (Platform.isIOS) {
      return CSWidget(child);
    }
    return ListTile(
      title: child,
    );
  }

  PageRoute getPageRoute({WidgetBuilder builder}) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: builder);
    } else {
      return MaterialPageRoute(builder: builder);
    }
  }

  Widget getSettingsButton({String text, Function onPress}) {
    if (Platform.isIOS) {
      return CSButton(CSButtonType.DEFAULT, text, onPress);
    } else {
      return ListTile(
        title: Text(text),
        onTap: onPress,
      );
    }
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
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          List<PlaceInfo> places = snapshot.data;
          return ExpansionTile(
              leading: Icon(Icons.history),
              title: Text(
                BlocProvider.of<LocalizationBloc>(context).localize('_archive', 'Archive'),
              ),
              children: places
                  .map((item) => [
                        Divider(),
                        Platform.isIOS
                            ? CupertinoListTile(
                                title: item.name,
                                onTap: () {
                                  changePlace(item.id);
                                  Navigator.of(context).pop();
                                },
                              )
                            : ListTile(
                                title: Text(item.name),
                                onTap: () {
                                  changePlace(item.id);
                                  Navigator.of(context).pop();
                                },
                              )
                      ])
                  .expand((element) => element)
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
    List<PlaceInfo> places = (json.decode(data) as List).map<PlaceInfo>((item) => PlaceInfo.fromMap(item)).toList().reversed.toList();
    return places;
  }
}
