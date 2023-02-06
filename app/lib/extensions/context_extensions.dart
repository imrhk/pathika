import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/localization.dart';
import '../models/app_settings.dart';
import '../screens/app_settings/app_settings_bloc.dart';
import '../screens/home/home_bloc.dart';
import '../theme/app_theme.dart';

extension ContextExtension on BuildContext {
  String get currentLanguage => read<AppSettingsBloc>().state.maybeWhen(
        orElse: () => const AppSettings().language,
        loaded: (appSetting) => appSetting.language,
      );

  AppTheme get currentTheme => read<AppSettingsBloc>().state.maybeWhen(
      orElse: () => AppTheme.light(),
      loaded: (appSettings) => appThemeMap[appSettings.theme]!.call());

  TextDirection get textDirection => read<AppSettingsBloc>().state.maybeWhen(
      orElse: () => TextDirection.ltr,
      loaded: (appSettings) =>
          appSettings.isRtl ? TextDirection.rtl : TextDirection.ltr);

  String? get currentPlace => read<HomeBloc>().state.maybeWhen(
        orElse: () => null,
        loaded: (placeId) => placeId,
      );

  String localize(String text, String defaultValue) =>
      watch<LocalizationBloc>().localize(text, defaultValue);

  ThemeData get theme => Theme.of(this);
}
