import 'package:devicelocale/devicelocale.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart' as pwm;

import 'ads/ad_config.dart';
import 'assets/assets_repository.dart';
import 'assets/flutter_assets_client.dart';
import 'cache/cache_client.dart';
import 'cache/cache_repository.dart';
import 'firebase_options.dart';
import 'localization/localization.dart';
import 'remote/remote_repository.dart';
import 'remote/rest_client.dart';
import 'screens/app_settings/app_settings_bloc.dart';
import 'screens/app_settings/app_settings_event.dart';
import 'screens/home/home.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_bloc.dart';
import 'theme/app_theme_event.dart';
import 'theme/app_theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(
    const _ProviderApp(
      child: _PathikaApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  await pwm.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: testDevices,
    ),
  );
  await Hive.initFlutter();
  Bloc.observer = AppBlocObserver(Logger());
}

class _ProviderApp extends StatefulWidget {
  final Widget child;

  const _ProviderApp({required this.child});

  @override
  State<_ProviderApp> createState() => _ProviderAppState();
}

class _ProviderAppState extends State<_ProviderApp> {
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => RemoteRepository(RestClient(_dio)),
        ),
        RepositoryProvider(
          create: (context) => AssetsRepository(
              FlutterAssetsClient(assetBundle: DefaultAssetBundle.of(context))),
        ),
        RepositoryProvider(
          create: (context) => CacheRepository(const CacheClient()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocalizationBloc>(
            create: (context) => LocalizationBloc(
              remoteRepository: context.read<RemoteRepository>(),
              assetsRepository: context.read<AssetsRepository>(),
            )..add(
                const FetchLocalization(localeDefault),
              ),
          ),
          BlocProvider<AppThemeBloc>(
            create: (BuildContext ctx) => AppThemeBloc()
              ..add(
                AppThemeInitialize(),
              ),
          ),
          BlocProvider<AppSettingsBloc>(
              create: (BuildContext context) => AppSettingsBloc(
                    cacheRepository: context.read<CacheRepository>(),
                    assetsRepository: context.read<AssetsRepository>(),
                    getDeviceLocale: () {
                      return Devicelocale.currentLocale
                          .then((value) => value ?? 'en')
                          .onError((error, stackTrace) => 'en');
                    },
                  )..add(const AppSettingsEvent.initialize())),
        ],
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _dio.close(force: true);
    super.dispose();
  }
}

class _PathikaApp extends StatelessWidget {
  const _PathikaApp();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (ctx, state) {
        return _AdaptiveApp(
          appTheme: state.appTheme,
          child: const HomeScreen(),
        );
      },
    );
  }
}

class _AdaptiveApp extends StatelessWidget with pwm.PlatformWidgetMixin {
  final AppTheme appTheme;
  @override
  final Widget child;

  const _AdaptiveApp({required this.appTheme, required this.child});
  @override
  Widget buildAndroid(BuildContext context) {
    return MaterialApp(
      theme: appTheme.themeDataMaterial,
      home: child,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoApp(
      theme: appTheme.themeDataCupertino,
      home: child,
    );
  }
}

class AppBlocObserver extends BlocObserver {
  final Logger? logger;

  AppBlocObserver(this.logger);

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger?.i('${bloc.runtimeType}: OnEvent >>> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger?.i(
        '${bloc.runtimeType}: OnChange >>> ${change.currentState} => ${change.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger?.e('${bloc.runtimeType}: OnError', error, stackTrace);
  }
}
