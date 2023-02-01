import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../places/place_details_page.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show HttpClient, Platform;

import '../common/constants.dart';
import '../common/material_card.dart';
import '../core/repository.dart';
import '../localization/localization.dart';
import 'app_language.dart';

class SelectLanguagePage extends StatefulWidget {
  final HttpClient httpClient;
  final String? currentLanguage;
  final bool fromSettings;

  const SelectLanguagePage({
    super.key,
    required this.httpClient,
    this.currentLanguage,
    this.fromSettings = false,
  });
  @override
  State createState() => _SelectLanguagePageState();
}

const appLanguage = 'app_language';

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  bool appLanguageChecked = false;
  String? appLangauge;

  AppTheme? _appTheme;

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
    if (sharedPref.containsKey(appLanguage)) {
      appLangauge = sharedPref.getString(appLanguage);
      bool isRTL = sharedPref.getBool('APP_LANGUAGE_IS_RTL') ?? false;
      if (context.mounted) {
        Navigator.of(context).pop({'rtl': isRTL, 'language': appLangauge});
      }
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
    _appTheme = BlocProvider.of<AppThemeBloc>(context).state.appThemeData;

    if (!appLanguageChecked) {
      return AppScaffold(
        body: Center(
          child: Platform.isIOS
              ? const CupertinoActivityIndicator()
              : const CircularProgressIndicator(),
        ),
      );
    }

    getAppBar() {
      return AppBar(
        title: Text(
          BlocProvider.of<LocalizationBloc>(context)
              .localize('select_language', 'Select Language'),
        ),
        automaticallyImplyLeading: widget.currentLanguage != null,
      );
    }

    getNavigationBar() {
      return CupertinoNavigationBar(
        leading: GestureDetector(
          child: Row(
            children: <Widget>[
              const Icon(CupertinoIcons.left_chevron,
                  color: CupertinoColors.activeBlue),
              Text(
                BlocProvider.of<LocalizationBloc>(context)
                    .localize('_settings', 'Settings'),
                style: const TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ],
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
        middle: Text(
          BlocProvider.of<LocalizationBloc>(context)
              .localize('select_language', 'Select Language'),
        ),
      );
    }

    final themeData = _appTheme?.themeDataMaterial;
    final Widget child;
    if (themeData == null) {
      child = buildLanguageList(context);
    } else {
      child = Theme(data: themeData, child: buildLanguageList(context));
    }
    return AppScaffold(
      getAppBar: getAppBar,
      getNavigationbar: getNavigationBar,
      body: child,
    );
  }

  Color getColorForTheme(List<int> argb) {
    Color color = Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
    bool isDark = _appTheme?.themeDataMaterial?.brightness == Brightness.dark;
    if (isDark) {
      return HSLColor.fromColor(color)
          .withSaturation(1.0)
          .withLightness(0.5)
          .toColor();
    } else {
      return color;
    }
  }

  Widget buildLanguageList(BuildContext buildContext) {
    final errorWidget = Center(
      child: Text(
        BlocProvider.of<LocalizationBloc>(context).localize(
            'check_connection', 'Error. Please check your connection'),
      ),
    );
    return FutureBuilder<List<AppLanguage>>(
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return errorWidget;
        } else if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          );
        } else {
          final data = snapshot.data;
          if (data == null) {
            return errorWidget;
          }
          final appLanguages = data;
          appLanguages.sort((a, b) {
            if (a.rtl == b.rtl) {
              final aName = a.name;
              final bName = b.name;
              if (aName != null && bName != null) {
                return aName.compareTo(bName);
              } else if (aName == null && bName == null) {
                return 0;
              } else if (aName != null) {
                return 1;
              } else {
                return -1;
              }
            } else {
              return a.rtl ? 1 : -1;
            }
          });
          //put english at top
          final indexOfEnglish =
              appLanguages.indexWhere((element) => element.id == "en");
          if (indexOfEnglish != -1) {
            final en = appLanguages[indexOfEnglish];
            appLanguages.removeAt(indexOfEnglish);
            appLanguages.insert(0, en);
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 60),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 225,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (ctx, index) {
                final item = appLanguages[index];
                return MaterialCard(
                  margin: const EdgeInsets.all(10),
                  elevation: 6,
                  shadowColor: getColorForTheme(item.color),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(0),
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
                          Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black.withAlpha(16)),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              item.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: getThemeTextColor(context),
                                  ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Text(
                                item.msg ?? '',
                                style: const TextStyle(
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

  Widget getLanguageItem({Widget? child, VoidCallback? onTap}) {
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
    Future<String?> response = kDebugMode
        ? DefaultAssetBundle.of(context)
            .loadString('assets_remote/assets/json/v1/languages.json')
        : Repository.getResponse(
            httpClient: widget.httpClient,
            url: '$baseUrl/assets/json/$apiVersion/languages.json',
            cacheTime: const Duration(days: 1),
          );

    return response.then((source) {
      if (source != null) {
        return Future.value(AppLanguage.fromList(json.decode(source)));
      } else {
        return [];
      }
    });
  }

  Color? getThemeTextColor(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoColors.label.resolveFrom(context);
    } else {
      return Theme.of(context).textTheme.bodyLarge?.color;
    }
  }
}
