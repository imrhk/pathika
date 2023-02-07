import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'theme_extensions.dart';

const Map<String, AppTheme Function()> appThemeMap = {
  'light': AppTheme.light,
  'colorful_light': AppTheme.colorfulLight,
  'dark': AppTheme.dark,
  'colorful_dark': AppTheme.colorfulDark,
  'gold_dark': AppTheme.goldDark,
};

final defaultAppTheme = AppTheme.light();

class AppTheme implements Equatable {
  final ThemeData? themeDataMaterial;
  final CupertinoThemeData? themeDataCupertino;
  final String label;

  AppTheme({
    this.themeDataMaterial,
    this.themeDataCupertino,
    required this.label,
  }) : assert(label.trim().isNotEmpty);

  static AppTheme light() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData(
          colorScheme: const ColorScheme.light(primary: Colors.black),
          extensions: [
            AppThemeExtension(highlightTextColor: Colors.white),
          ],
        ),
        themeDataCupertino: cupertinoThemeData.copyWith(
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle
                .copyWith(color: Colors.black),
          ),
        ),
        label: 'light');
  }

  static AppTheme colorfulLight() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData(
          colorScheme: const ColorScheme.light(primary: Colors.black),
          extensions: [
            AppThemeExtension(
              highlightTextColor: Colors.white,
              useColorsOnCard: true,
            ),
          ],
        ),
        themeDataCupertino: cupertinoThemeData.copyWith(
          primaryColor: Colors.black,
          textTheme: cupertinoThemeData.textTheme.copyWith(
            textStyle: cupertinoThemeData.textTheme.textStyle
                .copyWith(color: Colors.black),
          ),
        ),
        label: 'colorful_light');
  }

  static AppTheme dark() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          extensions: [
            AppThemeExtension(highlightTextColor: Colors.white),
          ],
        ),
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
        label: 'dark');
  }

  static AppTheme colorfulDark() {
    const cupertinoThemeData = CupertinoThemeData();
    return AppTheme(
        themeDataMaterial: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          extensions: [
            AppThemeExtension(
              highlightTextColor: Colors.white,
              useColorsOnCard: true,
            ),
          ],
        ),
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
        label: 'colorful_dark');
  }

  static AppTheme goldDark() {
    const colorGold = Color.fromARGB(255, 255, 215, 0);
    const linearGradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 252, 193, 0),
        Color.fromARGB(255, 224, 170, 62),
        Color.fromARGB(255, 184, 138, 68),
        Color.fromARGB(255, 184, 138, 68),
        Color.fromARGB(255, 224, 170, 62),
        Color.fromARGB(255, 252, 193, 0),
      ],
      tileMode: TileMode.clamp,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.25, 0.375, 0.5, 0.625, 0.75, 0.875],
    );

    TextStyle goldTextStyle = TextStyle(
        decorationColor: colorGold,
        foreground: Paint()
          ..shader = linearGradient
              .createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0))
          // ..color = const Color.fromARGB(255, 255, 215, 0)
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2));
    // const goldTextColor = Color.fromARGB(255, 255, 215, 0);

    final textTheme = TextTheme(
      displayLarge: goldTextStyle,
      bodyLarge: goldTextStyle,
      bodyMedium: goldTextStyle,
      bodySmall: goldTextStyle,
      displayMedium: goldTextStyle,
      displaySmall: goldTextStyle,
      headlineLarge: goldTextStyle,
      headlineMedium: goldTextStyle,
      headlineSmall: goldTextStyle,
      labelLarge: goldTextStyle,
      labelMedium: goldTextStyle,
      labelSmall: goldTextStyle,
      titleLarge: goldTextStyle,
      titleMedium: goldTextStyle,
      titleSmall: goldTextStyle,
    );

    final darkThemeMaterial = ThemeData.dark().copyWith();
    const darkThemeCupertino = CupertinoThemeData(brightness: Brightness.dark);
    return AppTheme(
      themeDataMaterial: darkThemeMaterial.copyWith(
        primaryColor: Colors.black,
        appBarTheme: darkThemeMaterial.appBarTheme.copyWith(
          titleTextStyle: goldTextStyle,
          toolbarTextStyle: goldTextStyle,
        ),
        textTheme: darkThemeMaterial.textTheme.merge(textTheme),
        unselectedWidgetColor: colorGold,
        iconTheme: const IconThemeData(color: colorGold),
        colorScheme: const ColorScheme.dark(
          onSurface: colorGold,
          secondary: colorGold,
        ),
        extensions: [
          AppThemeExtension(
            highlightTextColor: colorGold,
            textGradient: linearGradient,
          ),
        ],
      ),
      themeDataCupertino: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: CupertinoTextThemeData(
          navTitleTextStyle: darkThemeCupertino.textTheme.navTitleTextStyle,
          textStyle: darkThemeCupertino.textTheme.textStyle,
          actionTextStyle: darkThemeCupertino.textTheme.actionTextStyle,
          pickerTextStyle: darkThemeCupertino.textTheme.pickerTextStyle,
          tabLabelTextStyle: darkThemeCupertino.textTheme.tabLabelTextStyle,
          navActionTextStyle: darkThemeCupertino.textTheme.navActionTextStyle,
          dateTimePickerTextStyle:
              darkThemeCupertino.textTheme.dateTimePickerTextStyle,
          navLargeTitleTextStyle:
              darkThemeCupertino.textTheme.navLargeTitleTextStyle,
          primaryColor: const Color.fromARGB(255, 255, 215, 0),
        ).copyWith(
          actionTextStyle: goldTextStyle,
          dateTimePickerTextStyle: goldTextStyle,
          navActionTextStyle: goldTextStyle,
          navLargeTitleTextStyle: goldTextStyle,
          navTitleTextStyle: goldTextStyle,
          pickerTextStyle: goldTextStyle,
          tabLabelTextStyle: goldTextStyle,
          textStyle: goldTextStyle,
        ),
      ),
      label: 'gold_dark',
    );
  }

  @override
  List<Object> get props => [label];

  @override
  String toString() {
    return label;
  }

  @override
  bool? get stringify => true;
}
