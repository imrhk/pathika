import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart' as pwm
    show initialize;

import 'src/ads/ad_settings.dart';
import 'src/app.dart';
import 'src/utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(
    const ProviderApp(
      child: PathikaApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  await pwm.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AdSettings().initialize();
  await Hive.initFlutter();
}
