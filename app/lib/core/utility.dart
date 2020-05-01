import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

printInDebug(String msg) {
  if(kDebugMode) {
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