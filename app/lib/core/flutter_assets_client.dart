import 'package:flutter/services.dart';

import 'assets_client.dart';

class FlutterAssetsClient extends AssetsClient {
  final AssetBundle _assetBundle;
  const FlutterAssetsClient({required AssetBundle assetBundle})
      : _assetBundle = assetBundle;

  @override
  Future<String> loadStringAsset(String assetPath) {
    return _assetBundle.loadString(assetPath);
  }
}
