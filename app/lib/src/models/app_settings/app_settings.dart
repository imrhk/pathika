import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants/localization_constants.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(localeDefault) String language,
    @Default("light") String theme,
    @Default(false) bool isRtl,
    @Default(false) bool onlyVeg,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
