import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

abstract class AppThemeState extends Equatable {
  final AppTheme appTheme;

  const AppThemeState(this.appTheme);

  @override
  List<Object> get props => [appTheme];
}

class AppThemeUninitalized extends AppThemeState {
  AppThemeUninitalized()
      : super(WidgetsBinding.instance.window.platformBrightness ==
                Brightness.light
            ? AppTheme.light()
            : AppTheme.dark());

  @override
  String toString() => 'AppThemeUninitalized {appThemeData: $appTheme}';
}

class AppThemeLoaded extends AppThemeState {
  const AppThemeLoaded(super.appTheme);

  @override
  List<Object> get props => [appTheme];

  @override
  String toString() => 'AppThemeLoaded {appThemeData: $appTheme}';
}
