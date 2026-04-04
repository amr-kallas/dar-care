import 'dart:developer';

import 'package:dar_care/features/notifications/data/models/notification_model.dart';
import 'package:dar_care/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  Future<void> saveNotificationToDb(NotificationModel notification);
  Future<List<NotificationModel>> fetchNotificationsByCurrentUser();
  Future<void> markNotificationAsRead(String notificationId);
}

@LazySingleton(as: NotificationRemoteDataSource)
class FirebaseNotificationRemoteDataSource implements NotificationRemoteDataSource {
  FirebaseNotificationRemoteDataSource() : _messaging = FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  final SupabaseClient _supabase = Supabase.instance.client;

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

  @override
  Future<void> saveNotificationToDb(NotificationModel notification) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || notification.type.isEmpty) {
      return;
    }

    await _supabase.from('notifications').insert(notification.toInsertJson(userId: userId));
  }

  @override
  Future<List<NotificationModel>> fetchNotificationsByCurrentUser() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return const <NotificationModel>[];
    }

    final response = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((item) => NotificationModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList(growable: false);
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || notificationId.trim().isEmpty) {
      return;
    }

    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('user_id', userId);
  }
}
