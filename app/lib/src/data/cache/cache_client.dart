import 'package:hive/hive.dart';

import '../../models/app_settings/app_settings.dart';

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
  static const keyOnlyVeg = 'onlyVeg';
  static const keyThemeColor = 'themeColor';

  Future<Box> get _appSettingsBox => Hive.openBox('app_settings');

  Future<AppSettings> getAppSettings() =>
      _appSettingsBox.then((value) => AppSettings(
            language: value.get(keyLanguage),
            theme: value.get(keyTheme),
            isRtl: value.get(keyRtl),
            onlyVeg: value.get(keyOnlyVeg),
            themeColor: value.get(keyThemeColor),
          ));

  Future<void> setAppSettings(AppSettings appSettings) =>
      _appSettingsBox.then((value) {
        value
          ..put(keyLanguage, appSettings.language)
          ..put(keyTheme, appSettings.theme)
          ..put(keyRtl, appSettings.isRtl)
          ..put(keyOnlyVeg, appSettings.onlyVeg);
        if (appSettings.themeColor != null) {
          value.put(keyThemeColor, appSettings.themeColor);
        }
        value.flush();
      });

  Future<void> clearAppSettings() => _appSettingsBox.then((value) {
        value.delete(keyLanguage);
        value.delete(keyTheme);
        value.delete(keyRtl);
        value.delete(keyOnlyVeg);
        value.delete(keyThemeColor);
        value.flush();
      });

  Future<bool> appSettingsExists() =>
      _appSettingsBox.then((value) => value.isNotEmpty);
}
