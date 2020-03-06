import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:pathika/core/assets_client.dart';

class FlutterAssetsClient extends AssetsClient {
  final AssetBundle _assetBundle;
  const FlutterAssetsClient({@required AssetBundle assetBundle})
      : assert(assetBundle != null),
        _assetBundle = assetBundle;

  @override
  Future<String> loadStringAsset(String assetPath) {
    return _assetBundle.loadString(assetPath);
  }
}
