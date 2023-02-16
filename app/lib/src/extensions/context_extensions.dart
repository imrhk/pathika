import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../models/app_settings/app_settings.dart';
import '../screens/app_settings/bloc/app_settings_bloc.dart';
import '../screens/home/bloc/home_bloc.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';

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

  String? get currentPlace => read<HomeBloc>().state.whenOrNull(
        loaded: (placeId) => placeId,
      );

  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
}

extension AppThemeExtensionExtension on BuildContext {
  AppThemeExtension? _appThemeExtension() =>
      currentTheme.themeDataMaterial?.extension<AppThemeExtension>();
  bool get showColorsOnCards => _appThemeExtension()?.useColorsOnCard ?? false;

  Gradient? get textGradient => _appThemeExtension()?.textGradient;

  Color? get hightlightColor => _appThemeExtension()?.highlightTextColor;
}
