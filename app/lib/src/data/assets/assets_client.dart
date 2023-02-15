import '../../models/app_language/app_language.dart';

abstract class AssetsClient {
  const AssetsClient();

  Future<List<AppLanguage>> getAppLanguages();

  Future<Map<String, String>> getLocalizations(String language);
}
