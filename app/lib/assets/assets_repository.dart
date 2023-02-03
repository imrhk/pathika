import '../models/app_language.dart';
import 'assets_client.dart';

class AssetsRepository {
  final AssetsClient _assetsClient;

  AssetsRepository(this._assetsClient);

  Future<List<AppLanguage>> getAppLanguages() =>
      _assetsClient.getAppLanguages();

  Future<Map<String, String>> getLocalizations(String language) =>
      _assetsClient.getLocalizations(language);
}
