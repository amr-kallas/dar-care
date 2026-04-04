import 'package:dar_care/features/notifications/domain/entities/notification_intent.dart';

abstract class NotificationRepository {
  Stream<String> get onTokenRefresh;
  Stream<NotificationIntent> get onNotificationIntent;

  Future<void> initializeHandlers();
  Future<void> requestPermission();
  Future<String?> getToken();

  NotificationIntent? takePendingIntent();
}

