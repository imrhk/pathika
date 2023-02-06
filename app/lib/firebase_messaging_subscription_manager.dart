import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:universal_io/io.dart';

class FirebaseMessagingSubscriptionManager {
  static FirebaseMessagingSubscriptionManager? _singleton;

  factory FirebaseMessagingSubscriptionManager(Logger logger) {
    return _singleton ??=
        FirebaseMessagingSubscriptionManager._internal(logger);
  }

  FirebaseMessagingSubscriptionManager._internal(Logger logger) {
    _logger = logger;
  }

  static const _fcmTopics = 'fcm_topics';
  static const _keyLanguageTopic = 'language_topic';

  String get notificationTopicPrefix {
    return kDebugMode ? 'testLocale_' : 'locale_';
  }

  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;

  late final Logger _logger;

  Future<void> requestPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

      if (Platform.isIOS) {
        _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }
  }

  Future<void> onLanguageChanged(String newLanguage) async {
    if (newLanguage.isEmpty) {
      return;
    }

    final box = await Hive.openBox(_fcmTopics);
    final String previousLanguage =
        box.get(_keyLanguageTopic, defaultValue: '');
    if (previousLanguage.isNotEmpty && previousLanguage != newLanguage) {
      _logger.i(
          'unsubscribing from $notificationTopicPrefix$previousLanguage topic ');
      _firebaseMessaging
          .unsubscribeFromTopic('$notificationTopicPrefix$previousLanguage');
    }
    if (previousLanguage != newLanguage) {
      _logger
          .i('subscribing to $notificationTopicPrefix$previousLanguage topic ');
      _firebaseMessaging
          .subscribeToTopic('$notificationTopicPrefix$newLanguage');
      await box.put(_keyLanguageTopic, newLanguage);
      await box.flush();
    }
  }
}
