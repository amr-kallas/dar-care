import 'package:dar_care/features/notifications/domain/usecases/mark_notification_as_read_use_case.dart';
import 'package:dar_care/features/notifications/domain/usecases/get_notifications_history_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_history_state.dart';

class NotificationsHistoryCubit extends Cubit<NotificationsHistoryState> {
  NotificationsHistoryCubit(this._getNotifications, this._markAsRead)
    : super(const NotificationsHistoryState());

  final GetNotificationsHistoryUseCase _getNotifications;
  final MarkNotificationAsReadUseCase _markAsRead;

  Future<void> loadNotifications() async {
    emit(
      state.copyWith(
        status: NotificationsHistoryStatus.loading,
        clearError: true,
      ),
    );

    try {
      final notifications = await _getNotifications();
      emit(
        state.copyWith(
          status: NotificationsHistoryStatus.success,
          notifications: notifications,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NotificationsHistoryStatus.failure,
          errorMessage: 'Failed to load notifications.',
        ),
      );
    }
  }

  Future<void> markAsRead(String? notificationId) async {
    if (notificationId == null || notificationId.trim().isEmpty) {
      return;
    }

    final index = state.notifications.indexWhere((item) => item.id == notificationId);
    if (index == -1 || state.notifications[index].isRead) {
      return;
    }

    final updated = List.of(state.notifications);
    updated[index] = updated[index].copyWith(isRead: true);
    emit(state.copyWith(notifications: updated));

    try {
      await _markAsRead(notificationId);
    } catch (_) {
      // Keep optimistic read state in UI even if remote update fails.
    }
  }
}

