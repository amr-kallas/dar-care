import 'dart:developer';

import 'package:dar_care/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

/// Handles FCM background messages when app is terminated/backgrounded.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log(
    'FCM background message: ${message.messageId}, data: ${message.data}',
    name: 'NotificationFeature',
  );
}

void registerNotificationBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

abstract class NotificationRemoteDataSource {
  Stream<String> get onTokenRefresh;
  Stream<RemoteMessage> get onForegroundMessage;
  Stream<RemoteMessage> get onMessageOpenedApp;

  Future<void> setAutoInitEnabled(bool enabled);
  Future<void> setForegroundNotificationPresentationOptions();
  Future<RemoteMessage?> getInitialMessage();
  Future<NotificationSettings> requestPermission();
  Future<String?> getToken();
}

@LazySingleton(as: NotificationRemoteDataSource)
class FirebaseNotificationRemoteDataSource implements NotificationRemoteDataSource {
  FirebaseNotificationRemoteDataSource() : _messaging = FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<void> setAutoInitEnabled(bool enabled) {
    return _messaging.setAutoInitEnabled(enabled);
  }

  @override
  Future<void> setForegroundNotificationPresentationOptions() {
    return _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  @override
  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  @override
  Future<String?> getToken() => _messaging.getToken();
}
