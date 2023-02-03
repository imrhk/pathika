import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

class AppAdWidget extends StatefulWidget {
  const AppAdWidget({super.key});

  @override
  State<AppAdWidget> createState() => _AppAdWidgetState();
}

class _AppAdWidgetState extends State<AppAdWidget> {
  final adConfig = getAdConfig();
  BannerAd? bottomBarPromoAd;

  @override
  void initState() {
    super.initState();
    bottomBarPromoAd = adConfig != null
        ? BannerAd(
            size: AdSize.banner,
            adUnitId: adConfig!.adsId[placesBottomBarPromo]!,
            listener: BannerAdListener(
              onAdLoaded: (_) {
                setState(() {});
              },
            ),
            request: adRequest)
        : null;

    bottomBarPromoAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    if (bottomBarPromoAd == null) {
      return const SizedBox.shrink();
    } else {
      return Container(
        alignment: Alignment.center,
        width: bottomBarPromoAd!.size.width.toDouble(),
        height: bottomBarPromoAd!.size.height.toDouble(),
        child: AdWidget(ad: bottomBarPromoAd!),
      );
    }
  }

  @override
  void dispose() {
    bottomBarPromoAd?.dispose();
    super.dispose();
  }
}
