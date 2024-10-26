import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/locale.dart';
import 'package:logger/logger.dart';

import '../../../data/assets/assets_repository.dart';
import '../../../data/cache/cache_repository.dart';
import '../../../models/app_language/app_language.dart';
import '../../../models/app_settings/app_settings.dart';
import 'app_settings_event.dart';
import 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final CacheRepository _cacheRepository;
  final AssetsRepository _assetsRepository;
  final Future<String> Function() _getDeviceLocale;
  final Logger? _logger;

  AppSettingsBloc({
    required CacheRepository cacheRepository,
    required AssetsRepository assetsRepository,
    required Future<String> Function() getDeviceLocale,
    Logger? logger,
  })  : _cacheRepository = cacheRepository,
        _assetsRepository = assetsRepository,
        _getDeviceLocale = getDeviceLocale,
        _logger = logger,
        super(const AppSettingsState.uninitialized()) {
    on<AppSettingsEvent>(
      (event, emit) async {
        await event.when(
            initialize: () async => await _mapInitializeEventToState(emit),
            changeLanguage: (newLanguage, isRtl) async =>
                await _mapChangeLanguageEventToState(emit, newLanguage, isRtl),
            changeTheme: (newTheme, color) async =>
                await _mapChangeThemeEventToState(emit, newTheme, color),
            toggleVegPreference: () async =>
                await _mapSetOnlyVegEventToState(emit),
            clear: () async => await _mapClearSettingsEventToState(emit));
      },
    );
  }

  FutureOr<void> _mapInitializeEventToState(
    Emitter<AppSettingsState> emit,
  ) async {
    emit(const AppSettingsState.loading());
    try {
      final appSettingsExists = await _cacheRepository.appSettingsExists();
      if (appSettingsExists == false) {
        _logger?.i("app settings does not exist");
        final deviceLocale = await _getDeviceLocale();
        final locale = Locale.parse(deviceLocale);
        final deviceLanguage = locale.languageCode;

        final appSupportedLanguages = await _assetsRepository.getAppLanguages();
        final language = appSupportedLanguages.firstWhere(
          (e) => e.id == deviceLanguage,
          orElse: () => const AppLanguage(),
        );
        emit(
          AppSettingsState.loaded(
            AppSettings(
              language: language.id,
              isRtl: language.rtl,
            ),
          ),
        );
        _cacheRepository.setAppSettings(AppSettings(language: language.id));
      } else {
        final appSettings = await _cacheRepository.getAppSettings();
        _logger?.i("app settings exist. Emitting $appSettings");
        emit(AppSettingsState.loaded(appSettings));
      }
    } catch (e) {
      // default settings in case of error
      _logger?.e("error while loading app settings. $e",
          error: e as Error, stackTrace: e.stackTrace);
      emit(const AppSettingsState.loaded(AppSettings()));
    }
    return null;
  }

  FutureOr<void> _mapChangeLanguageEventToState(
    Emitter<AppSettingsState> emit,
    String newLanguage,
    bool isRtl,
  ) async {
    try {
      final appSettings = state.when<AppSettings>(
        uninitialized: () => AppSettings(language: newLanguage, isRtl: isRtl),
        loading: () => AppSettings(language: newLanguage, isRtl: isRtl),
        loaded: (settings) => settings.copyWith(
          language: newLanguage,
          isRtl: isRtl,
        ),
      );
      await _cacheRepository.setAppSettings(appSettings);
      emit(AppSettingsState.loaded(appSettings));
    } catch (_) {}
  }

  Future<void> _mapChangeThemeEventToState(
    Emitter<AppSettingsState> emit,
    String newTheme,
    int? color,
  ) async {
    try {
      final appSettings = state.when<AppSettings>(
        uninitialized: () => AppSettings(theme: newTheme, themeColor: color),
        loading: () => AppSettings(theme: newTheme, themeColor: color),
        loaded: (settings) => settings.copyWith(
          theme: newTheme,
          themeColor: color,
        ),
      );
      await _cacheRepository.setAppSettings(appSettings);
      emit(AppSettingsState.loaded(appSettings));
    } catch (_) {}
  }

  Future<void> _mapSetOnlyVegEventToState(
    Emitter<AppSettingsState> emit,
  ) async {
    try {
      final appSettings = state.whenOrNull<AppSettings>(
        loaded: (settings) => settings.copyWith(onlyVeg: !settings.onlyVeg),
      );
      if (appSettings != null) {
        await _cacheRepository.setAppSettings(appSettings);
        emit(AppSettingsState.loaded(appSettings));
      }
    } catch (_) {}
  }

  Future<void> _mapClearSettingsEventToState(
    Emitter<AppSettingsState> emit,
  ) async {
    try {
      await _cacheRepository.clearSettings();
      emit(const AppSettingsState.loaded(AppSettings()));
    } catch (_) {}
  }
}
