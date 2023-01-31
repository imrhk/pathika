import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_theme_bloc.dart';

printInDebug(String msg) {
  if (kDebugMode) {
    print(msg);
  }
}

const MaterialColor materialBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF999999),
    100: Color(0xFF999999),
    200: Color(0xFF999999),
    300: Color(0xFF999999),
    400: Color(0xFF999999),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF999999),
    700: Color(0xFF999999),
    800: Color(0xFF999999),
    900: Color(0xFF999999),
  },
);
const int _blackPrimaryValue = 0xFF999999;

const MaterialColor materialTransparent = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0x00000000),
    100: Color(0x00000000),
    200: Color(0x00000000),
    300: Color(0x00000000),
    400: Color(0x00000000),
    500: Color(0x00000000),
    600: Color(0x00000000),
    700: Color(0x00000000),
    800: Color(0x00000000),
    900: Color(0x00000000),
  },
);

extension AppThemeWidget on Widget {
  bool getColorsOnCard(BuildContext context) =>
      BlocProvider.of<AppThemeBloc>(context)
          .state
          .appThemeData
          .useColorsOnCard ??
      false;

  Gradient? getShimmerGradient(BuildContext context) =>
      BlocProvider.of<AppThemeBloc>(context).state.appThemeData.textGradient;
}
