import 'package:devicelocale/devicelocale.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart'
    as dio_logging_interceptor;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart' as pwm;
import 'package:universal_io/io.dart';

import 'ads/ad_config.dart';
import 'assets/assets_repository.dart';
import 'assets/flutter_assets_client.dart';
import 'cache/cache_client.dart';
import 'cache/cache_repository.dart';
import 'extensions/context_extensions.dart';
import 'firebase_options.dart';
import 'localization/localization.dart';
import 'remote/remote_repository.dart';
import 'remote/rest_client.dart';
import 'routes/routes.dart';
import 'screens/app_settings/app_settings_bloc.dart';
import 'screens/app_settings/app_settings_event.dart';
import 'screens/app_settings/app_settings_state.dart';
import 'screens/home/home.dart';
import 'screens/home/home_bloc.dart';
import 'screens/home/home_bloc_event.dart';
import 'theme/app_theme.dart';

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
  if (Platform.isAndroid || Platform.isIOS) {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: testDevices,
      ),
    );
  }
  await Hive.initFlutter();
}

class _ProviderApp extends StatefulWidget {
  final Widget child;

  const _ProviderApp({required this.child});

  @override
  State<_ProviderApp> createState() => _ProviderAppState();
}

class _ProviderAppState extends State<_ProviderApp> {
  late Dio _dio;
  late Logger _logger;

  @override
  void initState() {
    super.initState();

    // Dio Cache Global options
    final options = CacheOptions(
      store: HiveCacheStore(
        null,
      ),
      policy: CachePolicy.forceCache,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended when [true].
      allowPostMethod: false,
    );
    _dio = Dio();
    _dio.interceptors
      ..add(DioCacheInterceptor(options: options))
      ..add(
        dio_logging_interceptor.DioLoggingInterceptor(
          level: kDebugMode
              ? dio_logging_interceptor.Level.body
              : dio_logging_interceptor.Level.none,
          compact: false,
        ),
      );

    _logger = Logger(
      printer: SimplePrinter(colors: true),
    );
    Bloc.observer = AppBlocObserver(_logger);
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
        RepositoryProvider.value(value: _logger),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocalizationBloc>(
            create: (context) => LocalizationBloc(
              remoteRepository: context.read<RemoteRepository>(),
              assetsRepository: context.read<AssetsRepository>(),
            ),
          ),
          BlocProvider<AppSettingsBloc>(
            create: (BuildContext context) => AppSettingsBloc(
              cacheRepository: context.read<CacheRepository>(),
              assetsRepository: context.read<AssetsRepository>(),
              logger: context.read<Logger>(),
              getDeviceLocale: () {
                return Devicelocale.currentLocale
                    .then((value) => value ?? localeDefault)
                    .onError((error, stackTrace) => localeDefault);
              },
            )..add(const AppSettingsEvent.initialize()),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(context.read<RemoteRepository>())
              ..add(const HomeBlocEvent.initialize()),
          ),
        ],
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _dio.close(force: true);
    _logger.close();
    super.dispose();
  }
}

class _PathikaApp extends StatelessWidget {
  const _PathikaApp();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppSettingsBloc, AppSettingsState>(
      builder: (_, state) {
        return _AdaptiveApp(
          key: ValueKey(state.maybeWhen(
            orElse: () => null,
            loaded: (appSetting) => appSetting,
          )),
          appTheme: context.currentTheme,
          child: const HomeScreen(),
        );
      },
      listener: (context, _) {
        context
            .read<LocalizationBloc>()
            .add(ChangeLocalization(context.currentLanguage));
      },
      listenWhen: (previous, current) =>
          previous.whenOrNull(
            loaded: (appSetting) => appSetting.language,
          ) !=
          current.whenOrNull(
            loaded: (appSetting) => appSetting.language,
          ),
    );
  }
}

class _AdaptiveApp extends StatelessWidget with pwm.PlatformWidgetMixin {
  final AppTheme appTheme;
  @override
  final Widget child;

  const _AdaptiveApp({super.key, required this.appTheme, required this.child});
  @override
  Widget buildAndroid(BuildContext context) {
    return MaterialApp.router(
      theme: appTheme.themeDataMaterial,
      routerConfig: router,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoApp.router(
      theme: appTheme.themeDataCupertino,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
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
