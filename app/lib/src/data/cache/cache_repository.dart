import '../../models/app_settings/app_settings.dart';
import 'cache_client.dart';

class CacheRepository {
  final CacheClient cacheClient;
  CacheRepository(this.cacheClient);

  Future<AppSettings> getAppSettings() => cacheClient.getAppSettings();
  Future<void> setAppSettings(value) => cacheClient.setAppSettings(value);
  Future<bool> appSettingsExists() => cacheClient.appSettingsExists();
  Future<void> clearSettings() => cacheClient.clearAppSettings();
}
