import 'dart:convert';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/ads/ad_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show HttpClient;
import 'app_language/select_language_page.dart';
import 'common/constants.dart';
import 'core/flutter_assets_client.dart';
import 'core/repository.dart';

import 'localization/localization.dart';
import 'localization/localization_bloc.dart';
import 'localization/localization_event.dart';
import 'places/place_details_page.dart';
import 'theme/app_theme.dart';

void main() => runApp(PathikaApp(
      httpClient: HttpClient(),
    ));

class PathikaApp extends StatefulWidget {
  final HttpClient httpClient;
  const PathikaApp({Key key, this.httpClient}) : super(key: key);

  @override
  _PathikaAppState createState() => _PathikaAppState();
}

class _PathikaAppState extends State<PathikaApp> {
  AppTheme appTheme = AppTheme.Light();

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: getAdConfig().appId);
    _loadUserTheme();
  }

  _loadUserTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('APP_THEME')) {
      final appThemeValue = sharedPreferences.getString('APP_THEME');
      setState(() {
        appTheme = appThemeMap[appThemeValue]();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocalizationBloc>(
      create: (context) => LocalizationBloc(
        httpClient: widget.httpClient,
        assetsClient: FlutterAssetsClient(
          assetBundle: DefaultAssetBundle.of(context),
        ),
      )..add(
          FetchLocalization(LOCALE_DEFAULT),
        ),
      child: MaterialApp(
        theme: appTheme.themeData ??
            ThemeData(
                accentColor: Colors.white,
                primaryColor: Colors.black,
                textTheme: Theme.of(context).textTheme),
        // theme: ThemeData.dark(),
        home: InitPage(
          httpClient: widget.httpClient,
          appTheme: appTheme ?? AppTheme.Light(),
        ),
      ),
    );
  }
}

class InitPage extends StatefulWidget {
  final HttpClient httpClient;
  final AppTheme appTheme;

  const InitPage({Key key, this.httpClient, this.appTheme}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  String _language;
  bool _isRtl;
  String _placeId;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid || Platform.isIOS) _initFirebaseMessaging();
    _getLanguage(context);
  }

  _initFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {},
    );

    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      alert: true,
      badge: true,
      sound: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered.listen((event) {});
  }

  _getLanguage(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.containsKey(APP_LANGUAGE)) {
      String language = sharedPref.getString(APP_LANGUAGE);
      _isRtl = false;
      if (sharedPref.containsKey('APP_LANGUAGE_IS_RTL'))
        _isRtl = sharedPref.getBool('APP_LANGUAGE_IS_RTL');

      if (language != null && language.trim() != "") {
        _language = language;
        _getLatestPlace(context);
        BlocProvider.of<LocalizationBloc>(context)
            .add(FetchLocalization(_language));
      } else {
        return;
      }
    }
    Map<String, dynamic> languageDetails = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SelectLanguagePage(
          httpClient: widget.httpClient,
        ),
      ),
    );
    _appLanguageChanged(languageDetails);
  }

  String get notificationTopicPrefix {
    return kDebugMode ? 'testLocale_' : 'locale_';
  }

  void _appLanguageChanged(Map<String, dynamic> map) async {
    final previousLanguage = _language;
    final sharedPref = await SharedPreferences.getInstance();
    final language = map['language'];
    final isRTL = map['rtl'] ?? false;
    if (language != null && language.trim() != "") {
      sharedPref.setString(APP_LANGUAGE, language);
      sharedPref.setBool('APP_LANGUAGE_IS_RTL', isRTL);
      _language = language;
      _isRtl = isRTL;
      _getLatestPlace(context);
      if (Platform.isAndroid || Platform.isIOS) {
        if (previousLanguage != null && previousLanguage.trim() != "")
          _firebaseMessaging.unsubscribeFromTopic('$notificationTopicPrefix$previousLanguage');
        _firebaseMessaging.subscribeToTopic('$notificationTopicPrefix$language');
      }
      BlocProvider.of<LocalizationBloc>(context)
          .add(ChangeLocalization(_language));
    } else {
      _getLanguage(context);
    }
  }

  _getLatestPlace(BuildContext context) async {
    try {
      String data = await Repository.getResponse(
        httpClient: widget.httpClient,
        url: '$BASE_URL/assets/json/$API_VERSION/places.json',
      );
      List<String> places =
          (json.decode(data) as List).map((e) => e.toString()).toList();
      if (places.length > 0) {
        setState(() {
          _placeId = places[places.length - 1];
        });
      }
    } catch (onError) {}
  }

  void changePlace(String placeId) {
    if (placeId != _placeId)
      setState(() {
        _placeId = placeId;
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (ctx, state) {
      if (state is LocalizationError) {
        BlocProvider.of<LocalizationBloc>(context)
            .add(FetchLocalization(LOCALE_DEFAULT));
        return _buildLoadingScaffold();
      } else if (state is LocalizationLoaded) {
        if (_placeId == null) {
          return _buildLoadingScaffold();
        } else {
          return Directionality(
            textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: PlaceDetailsPage(
              placeId: _placeId,
              language: _language,
              httpClient: widget.httpClient,
              appTheme: widget.appTheme,
              appLanguageChanged: _appLanguageChanged,
              changePlace: changePlace,
            ),
          );
        }
      } else {
        return _buildLoadingScaffold();
      }
    });
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
