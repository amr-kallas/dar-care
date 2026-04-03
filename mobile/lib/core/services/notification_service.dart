import 'dart:async';
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
    name: 'NotificationService',
  );
}

enum NotificationIntentType {
  chat,
  providerNewOrder,
  clientOrderUpdate,
}

class NotificationIntent {
  const NotificationIntent._({
    required this.type,
    this.orderId,
    this.providerId,
    this.clientId,
    this.title,
  });

  final NotificationIntentType type;
  final String? orderId;
  final String? providerId;
  final String? clientId;
  final String? title;

  static NotificationIntent? fromMessage(RemoteMessage message) {
    final data = message.data;
    if (data.isEmpty) return null;

    final type =
        (data['type'] ?? data['notification_type'] ?? data['event'] ?? '')
            .toString()
            .trim()
            .toLowerCase();

    final orderId = _readValue(data, const ['order_id', 'orderId']);
    final providerId = _readValue(data, const ['provider_id', 'providerId']);
    final clientId = _readValue(data, const ['client_id', 'clientId']);
    final title =
        _readValue(data, const ['title']) ?? message.notification?.title;

    switch (type) {
      case 'chat':
      case 'chat_message':
      case 'chat_notification':
        if (providerId == null || clientId == null) {
          return null;
        }
        return NotificationIntent._(
          type: NotificationIntentType.chat,
          providerId: providerId,
          clientId: clientId,
          title: title,
        );
      case 'new_order':
      case 'provider_new_order':
        if (orderId == null) {
          return null;
        }
        return NotificationIntent._(
          type: NotificationIntentType.providerNewOrder,
          orderId: orderId,
        );
      case 'order_update':
      case 'client_order_update':
        return const NotificationIntent._(type: NotificationIntentType.clientOrderUpdate);
      default:
        return null;
    }
  }

  static String? _readValue(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return null;
  }
}

/// Handles Firebase Cloud Messaging setup and token lifecycle.
@lazySingleton
class NotificationService {
  NotificationService() : _messaging = FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  final StreamController<NotificationIntent> _intentController =
      StreamController<NotificationIntent>.broadcast();

  bool _isInitialized = false;
  NotificationIntent? _pendingIntent;

  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
  Stream<NotificationIntent> get onNotificationIntent => _intentController.stream;

  Future<void> initializeHandlers() async {
    if (_isInitialized) return;

    await _messaging.setAutoInitEnabled(true);

    // iOS/macOS foreground presentation options (safe no-op on Android).
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    _isInitialized = true;
  }

  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<String?> getToken() => _messaging.getToken();

  void _handleForegroundMessage(RemoteMessage message) {
    log(
      'FCM foreground message: ${message.messageId}, data: ${message.data}',
      name: 'NotificationService',
    );
  }

  NotificationIntent? takePendingIntent() {
    final intent = _pendingIntent;
    _pendingIntent = null;
    return intent;
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    log(
      'FCM opened-app message: ${message.messageId}, data: ${message.data}',
      name: 'NotificationService',
    );

    final intent = NotificationIntent.fromMessage(message);
    if (intent == null) {
      return;
    }

    if (_intentController.hasListener) {
      _intentController.add(intent);
    } else {
      _pendingIntent = intent;
    }
  }
}
