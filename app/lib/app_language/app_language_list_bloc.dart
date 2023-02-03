import '../assets/assets_repository.dart';
import '../models/app_language.dart';
import '../page_fetch/page_fetch_bloc.dart';
import '../remote/remote_repository.dart';
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
        return <AppLanguage>[...value]..sort(appLanguageComparator);
      } else {
        return value;
      }
    }).then((value) {
      //put english at top
      final indexOfEnglish = value.indexWhere((element) => element.id == "en");
      if (indexOfEnglish != -1) {
        final en = value[indexOfEnglish];
        value.removeAt(indexOfEnglish);
        value.insert(0, en);
      }
      return value.toList(growable: false);
    });
  }
}
