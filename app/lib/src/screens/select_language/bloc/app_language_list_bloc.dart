import '../../../blocs/page_fetch/page_fetch_bloc.dart';
import '../../../constants/localization_constants.dart';
import '../../../data/assets/assets_repository.dart';
import '../../../data/remote/remote_repository.dart';
import '../../../models/app_language/app_language.dart';
import 'app_language_list_event.dart';

class AppLanguageListBloc
    extends PageFetchBloc<AppLanguageListEvent, List<AppLanguage>> {
  final RemoteRepository _remoteRepository;
  final AssetsRepository _assetsRepository;

  AppLanguageListBloc(this._remoteRepository, this._assetsRepository);

  @override
  Future<List<AppLanguage>> fetchPage(AppLanguageListEvent event) {
    return event.source
        .when<Future<List<AppLanguage>>>(
            remote: () => _remoteRepository.getAppLanguages(),
            local: () => _assetsRepository.getAppLanguages())
        .then((value) {
      if (event.sorted) {
        return <AppLanguage>[...value]..sort();
      } else {
        return value;
      }
    }).then((value) {
      //put default language at top
      final indexOfDefaultLanguage =
          value.indexWhere((element) => element.id == localeDefault);
      if (indexOfDefaultLanguage != -1) {
        final defaultLanguage = value[indexOfDefaultLanguage];
        value.removeAt(indexOfDefaultLanguage);
        value.insert(0, defaultLanguage);
      }
      return value.toList(growable: false);
    });
  }
}
