import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/app_settings.dart';
import '../screens/app_settings/app_settings_bloc.dart';
import '../screens/home/home_bloc.dart';

extension ContextExtension on BuildContext {
  String get currentLanguage => read<AppSettingsBloc>().state.maybeWhen(
        orElse: () => const AppSettings().language,
        loaded: (appSetting) => appSetting.language,
      );

  String get currentPlace => read<HomeBloc>().state.maybeWhen(
        orElse: () => '',
        loaded: (placeId) => placeId,
      );
}
