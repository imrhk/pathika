import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/places/place_details_page.dart';
import 'package:pathika/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show HttpClient, Platform;

import '../common/constants.dart';
import '../common/material_card.dart';
import '../core/repository.dart';
import '../localization/localization.dart';
import 'app_language.dart';

class SelectLanguagePage extends StatefulWidget {
  final HttpClient httpClient;
  final String currentLanguage;
  final bool fromSettings;
  final AppTheme appTheme;

  const SelectLanguagePage({
    Key key,
    this.httpClient,
    this.currentLanguage,
    this.fromSettings = false,
    this.appTheme,
  }) : super(key: key);
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

const APP_LANGUAGE = 'app_language';

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  bool appLanguageChecked = false;
  String appLangauge;

  @override
  void initState() {
    super.initState();
    _checkForAppLanguage();
  }

  _checkForAppLanguage() async {
    if (widget.fromSettings) {
      setState(() {
        appLanguageChecked = true;
      });
      return;
    }
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.containsKey(APP_LANGUAGE)) {
      appLangauge = sharedPref.getString(APP_LANGUAGE);
      bool isRTL = false;
      if (sharedPref.containsKey('APP_LANGUAGE_IS_RTL')) {
        isRTL = sharedPref.getBool('APP_LANGUAGE_IS_RTL');
      }
      Navigator.of(context).pop({'rtl': isRTL, 'language': appLangauge});
    } else {
      setState(() {
        appLanguageChecked = true;
      });
    }
  }

  _saveAppLanguage(String id, bool isRTL) async {
    Navigator.of(context).pop({'rtl': isRTL, 'language': id});
  }

  @override
  Widget build(BuildContext context) {
    if (!appLanguageChecked) {
      return AppScaffold(
        child: Center(
          child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
        ),
      );
    }

    final getAppBar = () {
      return AppBar(
        title: Text(
          BlocProvider.of<LocalizationBloc>(context).localize('select_language', 'Select Language'),
        ),
        automaticallyImplyLeading: widget.currentLanguage != null,
      );
    };

    final getNavigationBar = () {
      return CupertinoNavigationBar(
        leading: GestureDetector(
          child: Row(
            children: <Widget>[
              Icon(CupertinoIcons.left_chevron, color: CupertinoColors.activeBlue),
              Text(
                BlocProvider.of<LocalizationBloc>(context).localize('_settings', 'Settings'),
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ],
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
        middle: Text(
          BlocProvider.of<LocalizationBloc>(context).localize('select_language', 'Select Language'),
        ),
      );
    };

    return AppScaffold(
      getAppBar: getAppBar,
      getNavigationbar: getNavigationBar,
      child: Theme(data: widget.appTheme.themeDataMaterial, child: buildLanguageList(context)),
    );
  }

  Color getColorForTheme(List<int> argb) {
    Color color = Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
    bool isDark = widget.appTheme.themeDataMaterial.brightness == Brightness.dark;
    if (isDark) {
      return HSLColor.fromColor(color).withSaturation(1.0).withLightness(0.5).toColor();
    } else {
      return color;
    }
  }

  Widget buildLanguageList(BuildContext buildContext) {
    return FutureBuilder<List<AppLanguage>>(
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              BlocProvider.of<LocalizationBloc>(context).localize('check_connection', 'Error. Please check your connection'),
            ),
          );
        } else if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
          );
        } else {
          final appLanguages = snapshot.data;
          appLanguages.sort((a, b) {
            if (a.rtl == b.rtl)
              return a.name.compareTo(b.name);
            else
              return a.rtl ?? false ? 1 : -1;
          });
          //put english at top
          final indexOfEnglish = appLanguages.indexWhere((element) => element.id == "en");
          if (indexOfEnglish != -1) {
            final en = appLanguages[indexOfEnglish];
            appLanguages.removeAt(indexOfEnglish);
            appLanguages.insert(0, en);
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 60),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 225,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (ctx, index) {
                final item = appLanguages[index];
                return MaterialCard(
                  margin: EdgeInsets.all(10),
                  elevation: 6,
                  shadowColor: getColorForTheme(item.color),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: getLanguageItem(
                      onTap: () {
                        final language = item.id;
                        _saveAppLanguage(language, item.rtl);
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(width: double.infinity, height: double.infinity, color: Colors.black.withAlpha(16)),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.headline4.copyWith(
                                    color: getThemeTextColor(context),
                                  ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Text(
                                item.msg,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: appLanguages.length,
            ),
          );
        }
      },
      future: _getData(context),
    );
  }

  Widget getLanguageItem({Widget child, Function onTap}) {
    if (Platform.isIOS) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: child,
      );
    }
  }

  Future<List<AppLanguage>> _getData(BuildContext context) async {
    Future<String> response = kDebugMode
        ? DefaultAssetBundle.of(context).loadString('assets_remote/assets/json/v1/languages.json')
        : Repository.getResponse(
            httpClient: widget.httpClient,
            url: '$BASE_URL/assets/json/$API_VERSION/languages.json',
            cacheTime: Duration(days: 1),
          );

    return response.then((source) => Future.value(AppLanguage.fromList(json.decode(source))));
  }

  Color getThemeTextColor(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoColors.label.resolveFrom(context);
    } else {
      return Theme.of(context).textTheme.bodyText1.color;
    }
  }
}
