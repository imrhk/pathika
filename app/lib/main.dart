import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

import 'src/ads/ad_settings.dart';
import 'src/app.dart';
import 'src/utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(
    AdaptiveConfigurationWidget(
      child: const ProviderApp(
        child: PathikaApp(),
      ),
    ),
  );
}

Future<void> _initializeApp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AdSettings().initialize();
  await Hive.initFlutter();
}
