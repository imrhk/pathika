import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:universal_io/io.dart';

import 'ad_secrets.dart' as ad_secret;

@immutable
class AdConfig {
  final String appId;
  final Map<String, String> adsId;

  const AdConfig({required this.appId, required this.adsId})
      : assert(appId != "");
}

const String placesBottomBarPromo = 'places_bottom_bar_promo';

// const androidAdConfig = AdConfig(
//     appId: '<app_id_from_google_ads>',
//     adsId: {placesBottomBarPromo: '<ad_id_from_google_ad>'});

AdConfig? getAdConfig() {
  if (kDebugMode) return null;
  if (Platform.isAndroid) {
    return kDebugMode
        ? ad_secret.androidDebugAdConfig
        : ad_secret.androidAdConfig;
  } else if (Platform.isIOS) {
    return ad_secret.iosAdConfig;
  } else {
    return null;
  }
}

const AdRequest adRequest = AdRequest(
  keywords: <String>[
    'travel',
    'place',
    'place info',
    'currency',
    'food',
    'climate',
    'dance',
    'tourist attractions',
    'trivia'
  ],
  nonPersonalizedAds: true,
);

final testDevices = kDebugMode
    ? <String>[
        'E231BC1BB1DD8D35748D031A5D27AC7D',
      ]
    : const <String>[]; // Android emulators are considered test devices
