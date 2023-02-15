import 'package:devicelocale/devicelocale.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart'
    as dio_logging_interceptor;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart' as pwm;

import 'blocs/localization/localization_bloc.dart';
import 'blocs/localization/localization_event.dart';
import 'constants/localization_constants.dart';
import 'data/assets/assets_repository.dart';
import 'data/assets/flutter_assets_client.dart';
import 'data/cache/cache_client.dart';
import 'data/cache/cache_repository.dart';
import 'data/remote/remote_repository.dart';
import 'data/remote/rest_client.dart';
import 'extensions/context_extensions.dart';
import 'routes/routes.dart';
import 'screens/app_settings/bloc/app_settings_bloc.dart';
import 'screens/app_settings/bloc/app_settings_event.dart';
import 'screens/app_settings/bloc/app_settings_state.dart';
import 'screens/home/bloc/home_bloc.dart';
import 'screens/home/bloc/home_bloc_event.dart';
import 'screens/home/home_screen.dart';
import 'theme/app_theme.dart';

class ProviderApp extends StatefulWidget {
  final Widget child;

  const ProviderApp({super.key, required this.child});

  @override
  State<ProviderApp> createState() => _ProviderAppState();
}

class _ProviderAppState extends State<ProviderApp> {
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

class PathikaApp extends StatelessWidget {
  const PathikaApp({super.key});

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
