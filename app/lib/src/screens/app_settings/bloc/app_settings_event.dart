import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_event.freezed.dart';

@freezed
class AppSettingsEvent with _$AppSettingsEvent {
  const factory AppSettingsEvent.initialize() = _Initialize;
  const factory AppSettingsEvent.changeLanguage(String language,
      [@Default(false) bool isRtl]) = _ChangeLanguage;
  const factory AppSettingsEvent.changeTheme(String theme) = _ChangeTheme;
  const factory AppSettingsEvent.toggleVegPreference() = _ToggleVegPreference;
  const factory AppSettingsEvent.clear() = _Clear;
}
