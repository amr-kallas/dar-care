import 'dart:async';

import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/notifications/domain/entities/notification_intent.dart';
import 'package:dar_care/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationIntentListener extends StatefulWidget {
  const NotificationIntentListener({required this.child, super.key});

  final Widget child;

  @override
  State<NotificationIntentListener> createState() =>
      _NotificationIntentListenerState();
}

class _NotificationIntentListenerState extends State<NotificationIntentListener> {
  NotificationRepository? _notificationRepository;
  StreamSubscription<NotificationIntent>? _intentSubscription;
  NotificationIntent? _pendingIntent;

  @override
  void initState() {
    super.initState();

    if (!getIt.isRegistered<NotificationRepository>()) {
      return;
    }

    _notificationRepository = getIt<NotificationRepository>();

    _intentSubscription = _notificationRepository!.onNotificationIntent.listen(
      _handleIntent,
    );

    final pendingIntent = _notificationRepository!.takePendingIntent();
    if (pendingIntent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _handleIntent(pendingIntent);
      });
    }
  }

  @override
  void dispose() {
    _intentSubscription?.cancel();
    super.dispose();
  }

  void _handleIntent(NotificationIntent intent) {
    final user = resolveAuthUser(context.read<AuthCubit>().state);
    if (user == null) {
      _pendingIntent = intent;
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
        if (user.role != UserRole.provider) {
          return;
        }

        final orderId = intent.orderId;
        if (orderId == null || orderId.isEmpty) {
          return;
        }

        AppRouter.router.go(AppRouter.buildProviderOrderDetailsPath(orderId));
        return;
      case NotificationIntentType.clientOrderUpdate:
        if (user.role != UserRole.client) {
          return;
        }

        AppRouter.router.go(AppRouter.myOrdersPath);
        return;
    }
  }

  void _tryHandlePendingIntent(AuthState state) {
    if (_pendingIntent == null) {
      return;
    }

    final user = resolveAuthUser(state);
    if (user == null) {
      return;
    }

    final intent = _pendingIntent!;
    _pendingIntent = null;
    _handleIntent(intent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) => _tryHandlePendingIntent(state),
      child: widget.child,
    );
  }
}

