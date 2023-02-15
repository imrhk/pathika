import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:universal_io/io.dart';

import 'ad_config.dart';

class AdSettings {
  Future<void> initialize() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await MobileAds.instance.initialize();
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: testDevices,
        ),
      );
    }
  }
}
