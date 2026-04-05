import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/notifications/data/models/notification_model.dart';
import 'package:dar_care/features/notifications/domain/entities/notification_intent.dart';
import 'package:dar_care/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dar_care/features/notifications/domain/usecases/mark_notification_as_read_use_case.dart';
import 'package:dar_care/features/notifications/domain/usecases/get_notifications_history_use_case.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notifications_history_cubit.dart';
import '../cubit/notifications_history_state.dart';

class NotificationsHistoryScreen extends StatelessWidget {
  const NotificationsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = getIt<NotificationRepository>();

    return BlocProvider(
      create: (_) => NotificationsHistoryCubit(
        GetNotificationsHistoryUseCase(repository),
        MarkNotificationAsReadUseCase(repository),
      )..loadNotifications(),
      child: const _NotificationsHistoryView(),
    );
  }
}

class _NotificationsHistoryView extends StatelessWidget {
  const _NotificationsHistoryView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(title: LocaleKeys.notifications.tr()),
      body: BlocBuilder<NotificationsHistoryCubit, NotificationsHistoryState>(
        builder: (context, state) {
          if (state.status == NotificationsHistoryStatus.loading &&
              state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NotificationsHistoryStatus.failure &&
              state.notifications.isEmpty) {
            return Center(
              child: Text(
                state.errorMessage ?? LocaleKeys.notifications_history_load_error.tr(),
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Text(LocaleKeys.notifications_history_empty.tr()),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<NotificationsHistoryCubit>().loadNotifications(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationHistoryTile(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationHistoryTile extends StatelessWidget {
  const _NotificationHistoryTile({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        await context.read<NotificationsHistoryCubit>().markAsRead(notification.id);
        if (!context.mounted) return;
        _navigateFromNotification(context, notification);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? (isDark ? AppColors.borderDark : AppColors.cardBorderLight)
                : AppColors.brightGreen,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title?.trim().isNotEmpty == true
                  ? notification.title!.trim()
                  : LocaleKeys.notifications_history_fallback_title.tr(),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (notification.body?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 6),
              Text(
                notification.body!.trim(),
                style: TextStyle(
                  color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
                ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              _formatType(notification.type),
              style: TextStyle(
                color: notification.isRead
                    ? (isDark ? AppColors.lightGrey : AppColors.mediumGrey)
                    : AppColors.brightGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _navigateFromNotification(
    BuildContext context,
    NotificationModel notification,
  ) {
    final intent = notification.toPayloadModel().toEntity();
    if (intent == null) {
      return;
    }

    switch (intent.type) {
      case NotificationIntentType.chat:
        final providerId = intent.providerId;
        final clientId = intent.clientId;
        if (providerId == null || clientId == null) {
          return;
        }
        AppRouter.router.go(
          AppRouter.buildChatRoomPath(
            providerId: providerId,
            clientId: clientId,
            title: intent.title,
          ),
        );
        return;
      case NotificationIntentType.providerNewOrder:
        final orderId = intent.orderId;
        if (orderId == null || orderId.isEmpty) {
          return;
        }
        AppRouter.router.go(AppRouter.buildProviderOrderDetailsPath(orderId));
        return;
      case NotificationIntentType.clientOrderUpdate:
        AppRouter.router.go(AppRouter.myOrdersPath);
        return;
    }
  }

  static String _formatType(String type) {
    switch (type) {
      case 'chat':
      case 'chat_message':
      case 'chat_notification':
        return LocaleKeys.notifications_history_type_chat.tr();
      case 'new_order':
      case 'provider_new_order':
        return LocaleKeys.notifications_history_type_order.tr();
      case 'order_update':
      case 'client_order_update':
        return LocaleKeys.notifications_history_type_order_update.tr();
      default:
        return type;
    }
  }
}

