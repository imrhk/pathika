import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

abstract class AppThemeState extends Equatable {
  final AppTheme appThemeData;

  const AppThemeState(this.appThemeData);

  @override
  List<Object> get props => [appThemeData];
}

class AppThemeUninitalized extends AppThemeState {
  AppThemeUninitalized()
      : super(WidgetsBinding.instance.window.platformBrightness ==
                Brightness.light
            ? AppTheme.light()
            : AppTheme.dark());

  @override
  String toString() => 'AppThemeUninitalized {appThemeData: $appThemeData}';
}

class AppThemeLoaded extends AppThemeState {
  const AppThemeLoaded(super.appThemeData);

  @override
  List<Object> get props => [appThemeData];

  @override
  String toString() => 'AppThemeLoaded {appThemeData: $appThemeData}';
}
