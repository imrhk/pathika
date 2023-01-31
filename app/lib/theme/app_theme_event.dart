import 'package:equatable/equatable.dart';
import 'package:pathika/theme/app_theme.dart';

abstract class AppThemeEvent extends Equatable {
  const AppThemeEvent();
}

class AppThemeInitialize extends AppThemeEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AppThemeInitialize';
}

class ChangeAppTheme extends AppThemeEvent {
  final AppTheme appThemeData;
  const ChangeAppTheme(this.appThemeData);

  @override
  List<Object> get props => [appThemeData];

  @override
  String toString() => "ChangeAppTheme {appThemeData : $appThemeData}";
}