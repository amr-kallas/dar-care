import 'dart:async';

import 'package:dar_care/core/theme/app_theme.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/services/notification_service.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/core/theme/theme_controller.dart';

/// Main application widget
class DarCareApp extends StatelessWidget {
  const DarCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
            ),
            BlocProvider(
              create: (context) => getIt<FavoritesCubit>()..loadFavorites(),
            ),
          ],
          child: const _NotificationIntentListener(
            child: _DarCareRouterView(),
          ),
        );
      },
    );
  }
}

class _DarCareRouterView extends StatelessWidget {
  const _DarCareRouterView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Router configuration
      routerConfig: AppRouter.router,

      // App metadata
      title: 'DarCare',
      debugShowCheckedModeBanner: false,

      // Localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeController.instance.themeMode,

      // DevicePreview integration
      builder: DevicePreview.appBuilder,
    );
  }
}

class _NotificationIntentListener extends StatefulWidget {
  const _NotificationIntentListener({required this.child});

  final Widget child;

  @override
  State<_NotificationIntentListener> createState() =>
      _NotificationIntentListenerState();
}

class _NotificationIntentListenerState extends State<_NotificationIntentListener> {
  NotificationService? _notificationService;
  StreamSubscription<NotificationIntent>? _intentSubscription;
  NotificationIntent? _pendingIntent;

  @override
  void initState() {
    super.initState();

    if (!getIt.isRegistered<NotificationService>()) {
      return;
    }

    _notificationService = getIt<NotificationService>();

    _intentSubscription = _notificationService!.onNotificationIntent.listen(
      _handleIntent,
    );

    final pendingIntent = _notificationService!.takePendingIntent();
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
