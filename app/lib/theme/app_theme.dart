import 'package:flutter/material.dart';

const Map<String, Function> appThemeMap = {
  'light': AppTheme.Light,
  'colorful_light': AppTheme.ColorfulLight,
  'dark': AppTheme.Dark,
  'colorful_dark': AppTheme.ColorfulDark,
  'gold_dark': AppTheme.GoldDark,
};

class AppTheme {
  final ThemeData themeData;
  final bool useColorsOnCard;
  final Color textColor;
  final String label;

 AppTheme(
      {this.themeData,
      this.useColorsOnCard = false,
      this.textColor,
      @required this.label})
      : assert(label != null && label.trim().isNotEmpty);

  static AppTheme Light() {
    return AppTheme(
      themeData: ThemeData.light()
          .copyWith(primaryColor: Colors.black, accentColor: Colors.lightBlue),
      useColorsOnCard: false,
      textColor: null,
      label: 'light'
    );
  }

  static AppTheme ColorfulLight() {
    return AppTheme(
        themeData: ThemeData.light().copyWith(
            primaryColor: Colors.black, accentColor: Colors.pinkAccent),
        useColorsOnCard: true,
        textColor: null,
        label: 'colorful_light'
        );
  }

  static AppTheme Dark() {
    return AppTheme(
        themeData: ThemeData.dark().copyWith(primaryColor: Colors.black),
        useColorsOnCard: false,
        textColor: null,
        label: 'dark');
  }

  static AppTheme ColorfulDark() {
    return AppTheme(
        themeData: ThemeData.dark().copyWith(primaryColor: Colors.black),
        useColorsOnCard: true,
        textColor: null,
        label: 'colorful_dark');
  }

  static AppTheme GoldDark() {
    return AppTheme(
      themeData: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        accentColor: Color.fromARGB(255, 255, 215, 0),
      ),
      useColorsOnCard: false,
      textColor: Color.fromARGB(255, 255, 215, 0),
      label: 'gold_dark'
    );
  }
}
