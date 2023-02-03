import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/app_settings.dart';

part 'app_settings_state.freezed.dart';

@freezed
class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState.uninitialized() = _Uninitialized;
  const factory AppSettingsState.loading() = _Loading;
  const factory AppSettingsState.loaded(AppSettings appSetting) = _Loaded;
}
