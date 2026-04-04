import 'package:dar_care/features/notifications/data/models/notification_model.dart';

enum NotificationsHistoryStatus { initial, loading, success, failure }

class NotificationsHistoryState {
  const NotificationsHistoryState({
    this.notifications = const <NotificationModel>[],
    this.status = NotificationsHistoryStatus.initial,
    this.errorMessage,
  });

  final List<NotificationModel> notifications;
  final NotificationsHistoryStatus status;
  final String? errorMessage;

  NotificationsHistoryState copyWith({
    List<NotificationModel>? notifications,
    NotificationsHistoryStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsHistoryState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

