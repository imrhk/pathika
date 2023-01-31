import 'dart:convert';
import 'dart:io';

import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/locale.dart';
import 'package:pathika/theme/app_theme_bloc.dart';
import 'package:pathika/theme/app_theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show HttpClient, Platform;
import 'app_language/app_language.dart';
import 'app_language/select_language_page.dart';
import 'common/constants.dart';
import 'core/flutter_assets_client.dart';
import 'core/repository.dart';

import 'localization/localization.dart';
import 'places/place_details_page.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationBloc>(
          create: (context) => LocalizationBloc(
            httpClient: HttpClient(),
            assetsClient: FlutterAssetsClient(
              assetBundle: DefaultAssetBundle.of(context),
            ),
          )..add(
              const FetchLocalization(localeDefault),
            ),
        ),
      ],
      child: PathikaApp(
        httpClient: HttpClient(),
      ),
    ),
  );
}

class PathikaApp extends StatefulWidget {
  final HttpClient httpClient;
  const PathikaApp({super.key, required this.httpClient});

  @override
  State createState() => _PathikaAppState();
}

class _PathikaAppState extends State<PathikaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppThemeBloc>(
      create: (BuildContext ctx) => AppThemeBloc()..add(AppThemeInitialize()),
      child: BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (ctx, state) {
          if (kDebugMode) {
            print('state: $state');
          }
          return _getPlateformApp(context, state.appThemeData);
        },
      ),
    );
  }

  Widget _getPlateformApp(BuildContext context, AppTheme appTheme) {
    if (Platform.isIOS) {
      return CupertinoApp(
        theme: appTheme.themeDataCupertino,
        home: _getHomeWidget(),
      );
    } else {
      return MaterialApp(
        theme: appTheme.themeDataMaterial,
        home: _getHomeWidget(),
      );
    }
  }

  Widget _getHomeWidget() {
    return InitPage(
      httpClient: widget.httpClient,
    );
  }
}

class InitPage extends StatefulWidget {
  final HttpClient httpClient;

  const InitPage({super.key, required this.httpClient});

  @override
  State createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  String? _language;
  bool _isRtl = false;
  String? _placeId;

  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid || Platform.isIOS) _initFirebaseMessaging();
    _getLanguage(context);
  }

  _initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

    if (Platform.isIOS || kIsWeb) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print('User granted permission: ${settings.authorizationStatus}');
      }
    }
  }

  _getLanguage(BuildContext context) async {
    final localizationBloc = context.read<LocalizationBloc>();
    final assetBundle = DefaultAssetBundle.of(context);
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.containsKey(appLanguage)) {
      String? language = sharedPref.getString(appLanguage);
      _isRtl = sharedPref.getBool('APP_LANGUAGE_IS_RTL') ?? false;

      if (language != null && language.trim() != "") {
        _language = language;
        _getLatestPlace();
        localizationBloc.add(FetchLocalization(language));
      } else {
        return;
      }
    } else {
      if (kIsWeb) {
        final appLanguage = AppLanguage.def();
        _appLanguageChanged(
            {'language': appLanguage.id, 'rtl': appLanguage.rtl});
      } else {
        final deviceLocale = (await Devicelocale.currentLocale) ?? 'en';

        final locale = Locale.parse(deviceLocale);
        final deviceLanguage = locale.languageCode;
        final supportedLanguagesJson = await assetBundle
            .loadString('assets_remote/assets/json/v1/languages.json');
        final supprtedLanguages =
            AppLanguage.fromList(json.decode(supportedLanguagesJson));
        final appLanguage = supprtedLanguages.firstWhere(
            (element) => element.id == deviceLanguage,
            orElse: () => AppLanguage.def());
        _appLanguageChanged(
            {'language': appLanguage.id, 'rtl': appLanguage.rtl});
      }
    }
  }

  String get notificationTopicPrefix {
    return kDebugMode ? 'testLocale_' : 'locale_';
  }

  void _appLanguageChanged(Map<String, dynamic> map) async {
    final localizationBloc = context.read<LocalizationBloc>();

    final previousLanguage = _language;
    if (previousLanguage == null) {
      return;
    }
    final sharedPref = await SharedPreferences.getInstance();
    final language = map['language'];
    final isRTL = map['rtl'] ?? false;
    if (language != null && language.trim() != "") {
      sharedPref.setString(appLanguage, language);
      sharedPref.setBool('APP_LANGUAGE_IS_RTL', isRTL);
      _language = language;
      _isRtl = isRTL;
      _getLatestPlace();
      if (Platform.isAndroid || Platform.isIOS) {
        if (previousLanguage.trim() != "") {
          _firebaseMessaging.unsubscribeFromTopic(
              '$notificationTopicPrefix$previousLanguage');
        }
        _firebaseMessaging
            .subscribeToTopic('$notificationTopicPrefix$language');
      }
      localizationBloc.add(ChangeLocalization(language));
    } else {
      if (context.mounted) {
        _getLanguage(context);
      }
    }
  }

  _getLatestPlace() async {
    try {
      String? data = await Repository.getResponse(
        httpClient: widget.httpClient,
        url: '$baseUrl/assets/json/$apiVersion/places.json',
      );
      if (data == null) {
        return;
      }
      List<String> places =
          (json.decode(data) as List).map((e) => e.toString()).toList();
      if (places.isNotEmpty) {
        setState(() {
          _placeId = places[places.length - 1];
        });
      }
    } catch (_) {}
  }

  void changePlace(String placeId) {
    if (placeId != _placeId) {
      setState(() {
        _placeId = placeId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (ctx, state) {
      if (state is LocalizationError) {
        BlocProvider.of<LocalizationBloc>(context)
            .add(const FetchLocalization(localeDefault));
        return _buildLoadingScaffold();
      } else if (state is LocalizationLoaded) {
        final placeId = _placeId;
        if (placeId == null) {
          return _buildLoadingScaffold();
        } else {
          return Directionality(
            textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: PlaceDetailsPage(
              placeId: placeId,
              language: _language ?? 'en',
              httpClient: widget.httpClient,
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
      body: Center(
        child: Platform.isIOS
            ? const CupertinoActivityIndicator()
            : const CircularProgressIndicator(),
      ),
    );
  }
}
