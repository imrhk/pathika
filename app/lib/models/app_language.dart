import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_language.freezed.dart';
part 'app_language.g.dart';

@freezed
class AppLanguage with _$AppLanguage {
  const factory AppLanguage({
    @Default("en") String id,
    String? name,
    String? msg,
    @Default([0, 0, 0, 0]) List<int> color,
    @Default(false) bool rtl,
  }) = _AppLanguage;

  factory AppLanguage.fromJson(Map<String, dynamic> json) =>
      _$AppLanguageFromJson(json);

  // @override
  // // ignore: library_private_types_in_public_api
  // int compareTo(_$_AppLanguage other) {
  //   if (rtl == other.rtl) {
  //     if (name != null && other.name != null) {
  //       return name!.compareTo(other.name!);
  //     } else if (name == null && other.name == null) {
  //       return 0;
  //     } else if (name != null) {
  //       return 1;
  //     } else {
  //       return -1;
  //     }
  //   } else {
  //     return rtl ? 1 : -1;
  //   }
  // }
}

int appLanguageComparator(AppLanguage a, AppLanguage b) {
  if (a.rtl == b.rtl) {
    final aName = a.name;
    final bName = b.name;
    if (aName != null && bName != null) {
      return aName.compareTo(bName);
    } else if (aName == null && bName == null) {
      return 0;
    } else if (aName != null) {
      return 1;
    } else {
      return -1;
    }
  } else {
    return a.rtl ? 1 : -1;
  }
}
