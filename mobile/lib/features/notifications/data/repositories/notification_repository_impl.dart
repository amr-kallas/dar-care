import 'dart:async';

import 'package:dar_care/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:dar_care/features/notifications/data/models/notification_payload_model.dart';
import 'package:dar_care/features/notifications/domain/entities/notification_intent.dart';
import 'package:dar_care/features/notifications/domain/repositories/notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;
  final StreamController<NotificationIntent> _intentController =
      StreamController<NotificationIntent>.broadcast();

  bool _isInitialized = false;
  NotificationIntent? _pendingIntent;

  @override
  Stream<String> get onTokenRefresh => _remoteDataSource.onTokenRefresh;

  @override
  Stream<NotificationIntent> get onNotificationIntent => _intentController.stream;

  @override
  Future<void> initializeHandlers() async {
    if (_isInitialized) return;

    await _remoteDataSource.setAutoInitEnabled(true);
    await _remoteDataSource.setForegroundNotificationPresentationOptions();

    _remoteDataSource.onForegroundMessage.listen(_handleForegroundMessage);
    _remoteDataSource.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    final initialMessage = await _remoteDataSource.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    _isInitialized = true;
  }

  @override
  Future<void> requestPermission() => _remoteDataSource.requestPermission();

  @override
  Future<String?> getToken() => _remoteDataSource.getToken();

  @override
  NotificationIntent? takePendingIntent() {
    final intent = _pendingIntent;
    _pendingIntent = null;
    return intent;
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Optionally handle foreground messages without causing UI navigation
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final payload = NotificationPayloadModel.fromRemoteMessage(message);
    if (payload.type.isEmpty) return;

    final intent = payload.toEntity();
    if (intent == null) return;

    if (_intentController.hasListener) {
      _intentController.add(intent);
    } else {
      _pendingIntent = intent;
    }
  }
}

