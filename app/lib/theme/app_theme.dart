import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Map<String, Function> appThemeMap = {
  'light': AppTheme.light,
  'colorful_light': AppTheme.colorfulLight,
  'dark': AppTheme.dark,
  'colorful_dark': AppTheme.colorfulDark,
  'gold_dark': AppTheme.goldDark,
};

class AppTheme implements Equatable {
  final ThemeData themeDataMaterial;
  final CupertinoThemeData themeDataCupertino;
  final bool useColorsOnCard;
  final Color textColor;
  final String label;

  AppTheme({this.themeDataMaterial, this.themeDataCupertino, this.useColorsOnCard = false, this.textColor, @required this.label})
      : assert(label != null && label.trim().isNotEmpty);

  static AppTheme light() {
    final cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.light().copyWith(primaryColor: Colors.black, accentColor: Colors.lightBlue),
        themeDataCupertino: cupertinoThemeData.copyWith(
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle.copyWith(color: Colors.black),
          ),
        ),
        useColorsOnCard: false,
        textColor: null,
        label: 'light');
  }

  static AppTheme colorfulLight() {
    final cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.light().copyWith(primaryColor: Colors.black, accentColor: Colors.pinkAccent),
        themeDataCupertino: cupertinoThemeData.copyWith(
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle.copyWith(color: Colors.black),
          ),
        ),
        useColorsOnCard: true,
        textColor: null,
        label: 'colorful_light');
  }

  static AppTheme dark() {
    final cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.dark().copyWith(primaryColor: Colors.black),
        themeDataCupertino: cupertinoThemeData.copyWith(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle.copyWith(color: Colors.white),
            navLargeTitleTextStyle: cupertinoThemeData.textTheme.navLargeTitleTextStyle.copyWith(color: Colors.white),
            navTitleTextStyle: cupertinoThemeData.textTheme.navTitleTextStyle.copyWith(color: Colors.white),
          ),
        ),
        useColorsOnCard: false,
        textColor: null,
        label: 'dark');
  }

  static AppTheme colorfulDark() {
    final cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.dark().copyWith(primaryColor: Colors.black),
        themeDataCupertino: cupertinoThemeData.copyWith(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle.copyWith(color: Colors.white),
            navLargeTitleTextStyle: cupertinoThemeData.textTheme.navLargeTitleTextStyle.copyWith(color: Colors.white),
            navTitleTextStyle: cupertinoThemeData.textTheme.navTitleTextStyle.copyWith(color: Colors.white),
          ),
        ),
        useColorsOnCard: true,
        textColor: null,
        label: 'colorful_dark');
  }

  static AppTheme goldDark() {
    return AppTheme(
        themeDataMaterial: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          accentColor: Color.fromARGB(255, 255, 215, 0),
        ),
        themeDataCupertino: CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 215, 0),
            ),
          ),
        ),
        useColorsOnCard: false,
        textColor: Color.fromARGB(255, 255, 215, 0),
        label: 'gold_dark');
  }

  @override
  List<Object> get props => [label];

  @override
  String toString() {
    return label;
  }

  @override
  int get hashCode => label.hashCode;

  @override
  bool get stringify => false;

  @override
  bool operator == (dynamic other) {
    return other is AppTheme && other.label == this.label;
  }
}
