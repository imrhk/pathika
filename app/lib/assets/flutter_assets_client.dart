import 'dart:convert';

import 'package:flutter/services.dart';

import '../localization/constants.dart';
import '../models/app_language.dart';
import 'assets_client.dart';

class FlutterAssetsClient extends AssetsClient with _$FLutterAssetsClient {
  @override
  final AssetBundle _assetBundle;
  const FlutterAssetsClient({required AssetBundle assetBundle})
      : _assetBundle = assetBundle;

  @override
  Future<List<AppLanguage>> getAppLanguages();

  @override
  Future<Map<String, String>> getLocalizations(String language);
}

mixin _$FLutterAssetsClient {
  AssetBundle get _assetBundle;

  Future<List<AppLanguage>> getAppLanguages() async {
    final appLanguages = await _assetBundle
        .loadString('assets_remote/assets/json/v1/languages.json')
        .then((value) => value as List<dynamic>?)
        .then((value) => value
            ?.map((e) => AppLanguage.fromJson(e as Map<String, dynamic>))
            .toList());

    if (appLanguages != null && appLanguages.isNotEmpty) {
      return appLanguages;
    } else {
      return [const AppLanguage()];
    }
  }

  Future<Map<String, String>> getLocalizations(String language) async {
    final String data = await _assetBundle
        .loadString('$baseLocalizationAssetPath/$language.json');

    Map<String, String>? map = (json.decode(data) as Map).map<String, String>(
        (key, value) => MapEntry<String, String>(key, value.toString()));
    return map;
  }
}
