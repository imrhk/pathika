import 'package:freezed_annotation/freezed_annotation.dart';

import '../page_fetch/page_fetch_event.dart';

part 'app_language_list_event.freezed.dart';

class AppLanguageListEvent extends PageFetchEvent {
  final AppLanguageDataSource source;
  final bool sorted;

  const AppLanguageListEvent(this.source, [this.sorted = false]);
}

@freezed
class AppLanguageDataSource with _$AppLanguageDataSource {
  const factory AppLanguageDataSource.remote() = _Remote;
  const factory AppLanguageDataSource.local() = _Local;
}
