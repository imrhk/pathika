import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const baseUrl =
    kDebugMode ? "http://192.168.1.3:5003" : "https://cdn.pathika.litedevs.com";
const apiUrl = "https://pathika.litedevs.com/api";
const apiVersion = 'v1';
const privaryPolicyUrl = "https://pathika.litedevs.com/privacy_policy.html";
const webAppUrl = 'https://pathika.litedevs.com/';

// https://www.regextester.com/106421
final regexEmojies = RegExp(
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

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
