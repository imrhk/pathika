import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants/localization_constants.dart';

part 'app_language.freezed.dart';
part 'app_language.g.dart';

@freezed
class AppLanguage with _$AppLanguage implements Comparable<AppLanguage> {
  const factory AppLanguage({
    @Default(localeDefault) String id,
    String? name,
    String? msg,
    @Default([0, 0, 0, 0]) List<int> color,
    @Default(false) bool rtl,
  }) = _AppLanguage;

  const AppLanguage._();

  factory AppLanguage.fromJson(Map<String, dynamic> json) =>
      _$AppLanguageFromJson(json);

  @override
  int compareTo(AppLanguage other) {
    if (rtl == other.rtl) {
      if (name != null && other.name != null) {
        return name!.compareTo(other.name!);
      } else if (name == null && other.name == null) {
        return 0;
      } else if (name != null) {
        return 1;
      } else {
        return -1;
      }
    } else {
      return rtl ? 1 : -1;
    }
  }
}
