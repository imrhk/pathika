import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/locale.dart';

import '../../assets/assets_repository.dart';
import '../../cache/cache_repository.dart';
import '../../models/app_language.dart';
import '../../models/app_settings.dart';
import 'app_settings_event.dart';
import 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final CacheRepository _cacheRepository;
  final AssetsRepository _assetsRepository;
  final Future<String> Function() _getDeviceLocale;

  AppSettingsBloc({
    required CacheRepository cacheRepository,
    required AssetsRepository assetsRepository,
    required Future<String> Function() getDeviceLocale,
  })  : _cacheRepository = cacheRepository,
        _assetsRepository = assetsRepository,
        _getDeviceLocale = getDeviceLocale,
        super(const AppSettingsState.uninitialized()) {
    on<AppSettingsEvent>(
      (event, emit) async {
        await event.when(
            initialize: () async => await _mapInitializeEventToState(emit),
            changeLanguage: (newLanguage, isRtl) async =>
                await _mapChangeLanguageEventToState(emit, newLanguage, isRtl),
            changeTheme: (newTheme) async =>
                await _mapChangeThemeEventToState(emit, newTheme),
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
        emit(AppSettingsState.loaded(appSettings));
      }
    } catch (_) {
      // default settings in case of error
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
  ) async {
    try {
      final appSettings = state.when<AppSettings>(
        uninitialized: () => AppSettings(
          theme: newTheme,
        ),
        loading: () => AppSettings(
          theme: newTheme,
        ),
        loaded: (settings) => settings.copyWith(theme: newTheme),
      );
      await _cacheRepository.setAppSettings(appSettings);
      emit(AppSettingsState.loaded(appSettings));
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
