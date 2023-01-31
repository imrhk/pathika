import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Map<String, AppTheme Function()> appThemeMap = {
  'light': AppTheme.light,
  'colorful_light': AppTheme.colorfulLight,
  'dark': AppTheme.dark,
  'colorful_dark': AppTheme.colorfulDark,
  'gold_dark': AppTheme.goldDark,
};

class AppTheme implements Equatable {
  final ThemeData? themeDataMaterial;
  final CupertinoThemeData? themeDataCupertino;
  final bool? useColorsOnCard;
  final Color? highlightTextColor;
  final String label;
  final Gradient? textGradient;

  AppTheme({
    this.themeDataMaterial,
    this.themeDataCupertino,
    this.useColorsOnCard = false,
    this.highlightTextColor,
    required this.label,
    this.textGradient,
  }) : assert(label.trim().isNotEmpty);

  static AppTheme light() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlue)),
        themeDataCupertino: cupertinoThemeData.copyWith(
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle
                .copyWith(color: Colors.black),
          ),
        ),
        useColorsOnCard: false,
        highlightTextColor: Colors.white,
        label: 'light');
  }

  static AppTheme colorfulLight() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.pinkAccent)),
        themeDataCupertino: cupertinoThemeData.copyWith(
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle
                .copyWith(color: Colors.black),
          ),
        ),
        useColorsOnCard: true,
        highlightTextColor: Colors.white,
        label: 'colorful_light');
  }

  static AppTheme dark() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial:
            ThemeData.dark().copyWith(primaryColor: Colors.black),
        themeDataCupertino: cupertinoThemeData.copyWith(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle
                .copyWith(color: Colors.white),
            navLargeTitleTextStyle: cupertinoThemeData
                .textTheme.navLargeTitleTextStyle
                .copyWith(color: Colors.white),
            navTitleTextStyle: cupertinoThemeData.textTheme.navTitleTextStyle
                .copyWith(color: Colors.white),
          ),
        ),
        useColorsOnCard: false,
        highlightTextColor: Colors.white,
        label: 'dark');
  }

  static AppTheme colorfulDark() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial:
            ThemeData.dark().copyWith(primaryColor: Colors.black),
        themeDataCupertino: cupertinoThemeData.copyWith(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle
                .copyWith(color: Colors.white),
            navLargeTitleTextStyle: cupertinoThemeData
                .textTheme.navLargeTitleTextStyle
                .copyWith(color: Colors.white),
            navTitleTextStyle: cupertinoThemeData.textTheme.navTitleTextStyle
                .copyWith(color: Colors.white),
          ),
        ),
        useColorsOnCard: true,
        highlightTextColor: Colors.white,
        label: 'colorful_dark');
  }

  static AppTheme goldDark() {
    const goldTextColor = Color.fromARGB(255, 255, 215, 0);
    final darkThemeMaterial = ThemeData.dark();
    const darkThemeCupertino = CupertinoThemeData(brightness: Brightness.dark);
    return AppTheme(
      themeDataMaterial: darkThemeMaterial.copyWith(
        primaryColor: Colors.black,
        textTheme: darkThemeMaterial.textTheme.apply(
          bodyColor: const Color.fromARGB(255, 255, 215, 0),
          displayColor: const Color.fromARGB(255, 255, 215, 0),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color.fromARGB(255, 255, 215, 0)),
      ),
      themeDataCupertino: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: CupertinoTextThemeData(
          navTitleTextStyle: darkThemeCupertino.textTheme.navTitleTextStyle
              .copyWith(color: goldTextColor),
          textStyle: darkThemeCupertino.textTheme.textStyle
              .copyWith(color: goldTextColor),
          actionTextStyle: darkThemeCupertino.textTheme.actionTextStyle
              .copyWith(color: goldTextColor),
          pickerTextStyle: darkThemeCupertino.textTheme.pickerTextStyle
              .copyWith(color: goldTextColor),
          tabLabelTextStyle: darkThemeCupertino.textTheme.tabLabelTextStyle
              .copyWith(color: goldTextColor),
          navActionTextStyle: darkThemeCupertino.textTheme.navActionTextStyle
              .copyWith(color: goldTextColor),
          dateTimePickerTextStyle: darkThemeCupertino
              .textTheme.dateTimePickerTextStyle
              .copyWith(color: goldTextColor),
          navLargeTitleTextStyle: darkThemeCupertino
              .textTheme.navLargeTitleTextStyle
              .copyWith(color: goldTextColor),
          primaryColor: const Color.fromARGB(255, 255, 215, 0),
        ),
      ),
      useColorsOnCard: false,
      highlightTextColor: const Color.fromARGB(255, 255, 215, 0),
      label: 'gold_dark',
      textGradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 249, 242, 149),
          Color.fromARGB(255, 224, 170, 62),
          Color.fromARGB(255, 252, 193, 0),
          Color.fromARGB(255, 184, 138, 68),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.25, 0.5, 0.75, 1.0],
      ),
    );
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
  bool operator ==(dynamic other) {
    return other is AppTheme && other.label == label;
  }
}
