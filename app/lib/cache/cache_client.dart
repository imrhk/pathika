import 'package:hive/hive.dart';

import '../models/app_settings.dart';

class CacheClient with _$CacheClient {
  const CacheClient();
  @override
  Future<AppSettings> getAppSettings();

  @override
  Future<void> setAppSettings(AppSettings appSettings);

  @override
  Future<void> clearAppSettings();

  @override
  Future<bool> appSettingsExists();
}

mixin _$CacheClient {
  static const keyLanguage = 'language';
  static const keyTheme = 'theme';
  static const keyRtl = 'isRtl';

  Future<Box> get _appSettingsBox => Hive.openBox('app_settings');

  Future<AppSettings> getAppSettings() =>
      _appSettingsBox.then((value) => AppSettings(
          language: value.get(keyLanguage),
          theme: value.get(keyTheme),
          isRtl: value.get(keyRtl)));

  Future<void> setAppSettings(AppSettings appSettings) =>
      _appSettingsBox.then((value) {
        value.put(keyLanguage, appSettings.language);
        value.put(keyTheme, appSettings.theme);
        value.put(keyRtl, appSettings.isRtl);
      });

  Future<void> clearAppSettings() => _appSettingsBox.then((value) {
        value.delete(keyLanguage);
        value.delete(keyTheme);
        value.delete(keyRtl);
      });

  Future<bool> appSettingsExists() =>
      _appSettingsBox.then((value) => value.isEmpty);
}
