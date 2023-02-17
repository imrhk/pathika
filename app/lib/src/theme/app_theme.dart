import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'theme_extensions.dart';

const Map<String, AppTheme Function([Color?])> appThemeMap = {
  'light': AppTheme.light,
  'colorful_light': AppTheme.colorfulLight,
  'dark': AppTheme.dark,
  'colorful_dark': AppTheme.colorfulDark,
  'gold_dark': AppTheme.goldDark,
  'neon': AppTheme.neon,
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

  factory AppTheme.light([Color? color]) {
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

  factory AppTheme.colorfulLight([Color? color]) {
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

  factory AppTheme.dark([Color? color]) {
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

  factory AppTheme.colorfulDark([Color? color]) {
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

  factory AppTheme.goldDark([Color? color]) {
    const textColor = Color.fromARGB(255, 255, 215, 0);
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

    final foregoundPaint = Paint()
      ..shader = linearGradient
          .createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0))
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

    TextStyle goldTextStyle = TextStyle(
      decorationColor: textColor,
      foreground: foregoundPaint,
    );

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
        unselectedWidgetColor: textColor,
        iconTheme: const IconThemeData(color: textColor),
        colorScheme: const ColorScheme.dark(
          onSurface: textColor,
          secondary: textColor,
        ),
        extensions: [
          AppThemeExtension(
            highlightTextColor: textColor,
            textGradient: linearGradient,
            useEmojiChars: false,
          ),
        ],
      ),
      themeDataCupertino: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: darkThemeCupertino.textTheme.copyWith(
          actionTextStyle:
              darkThemeCupertino.textTheme.actionTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          dateTimePickerTextStyle:
              darkThemeCupertino.textTheme.dateTimePickerTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          navActionTextStyle:
              darkThemeCupertino.textTheme.navActionTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          navLargeTitleTextStyle:
              darkThemeCupertino.textTheme.navLargeTitleTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          navTitleTextStyle:
              darkThemeCupertino.textTheme.navTitleTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          pickerTextStyle:
              darkThemeCupertino.textTheme.pickerTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          primaryColor: textColor,
          tabLabelTextStyle:
              darkThemeCupertino.textTheme.tabLabelTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          textStyle: darkThemeCupertino.textTheme.textStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
        ),
      ),
      label: 'gold_dark',
    );
  }

  factory AppTheme.neon([Color? color]) {
    final textColor = color ?? Colors.pink[300]!;
    final shader = LinearGradient(
      colors: [
        textColor,
        textColor,
      ],
      tileMode: TileMode.clamp,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.5, 1.0],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0));

    final foregoundPaint = Paint()
      ..color = Colors.white
      ..shader = shader
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 10);

    final shadowForegoundPaint = Paint()
      ..color = Colors.white
      ..shader = shader
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10);

    TextStyle neonTextStyle = TextStyle(
      decorationColor: textColor,
      foreground: foregoundPaint,
    );

    // const goldTextColor = Color.fromARGB(255, 255, 215, 0);

    final textTheme = TextTheme(
      displayLarge: neonTextStyle,
      bodyLarge: neonTextStyle,
      bodyMedium: neonTextStyle,
      bodySmall: neonTextStyle,
      displayMedium: neonTextStyle,
      displaySmall: neonTextStyle,
      headlineLarge: neonTextStyle,
      headlineMedium: neonTextStyle,
      headlineSmall: neonTextStyle,
      labelLarge: neonTextStyle,
      labelMedium: neonTextStyle,
      labelSmall: neonTextStyle,
      titleLarge: neonTextStyle,
      titleMedium: neonTextStyle,
      titleSmall: neonTextStyle,
    );

    final darkThemeMaterial = ThemeData.dark().copyWith();
    const darkThemeCupertino = CupertinoThemeData(brightness: Brightness.dark);
    return AppTheme(
      themeDataMaterial: darkThemeMaterial.copyWith(
        primaryColor: Colors.black,
        appBarTheme: darkThemeMaterial.appBarTheme.copyWith(
          titleTextStyle: neonTextStyle,
          toolbarTextStyle: neonTextStyle,
        ),
        cardTheme: darkThemeMaterial.cardTheme.copyWith(
          color: Colors.black,
          shadowColor: textColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: textColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textTheme: darkThemeMaterial.textTheme.merge(textTheme),
        unselectedWidgetColor: textColor,
        iconTheme: IconThemeData(color: textColor),
        colorScheme: ColorScheme.dark(
          onSurface: textColor,
          secondary: textColor,
        ),
        extensions: [
          AppThemeExtension(
            highlightTextColor: textColor,
            shadowTextPaint: shadowForegoundPaint,
            useEmojiChars: false,
          ),
        ],
      ),
      themeDataCupertino: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: darkThemeCupertino.textTheme.copyWith(
          actionTextStyle:
              darkThemeCupertino.textTheme.actionTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          dateTimePickerTextStyle:
              darkThemeCupertino.textTheme.dateTimePickerTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          navActionTextStyle:
              darkThemeCupertino.textTheme.navActionTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          navLargeTitleTextStyle:
              darkThemeCupertino.textTheme.navLargeTitleTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          navTitleTextStyle:
              darkThemeCupertino.textTheme.navTitleTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          pickerTextStyle:
              darkThemeCupertino.textTheme.pickerTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          primaryColor: textColor,
          tabLabelTextStyle:
              darkThemeCupertino.textTheme.tabLabelTextStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
          textStyle: darkThemeCupertino.textTheme.textStyle.copyWith(
            foreground: foregoundPaint,
            decorationColor: textColor,
          ),
        ),
      ),
      label: 'neon',
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
