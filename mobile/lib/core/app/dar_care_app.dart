import 'package:dar_care/core/theme/app_theme.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/notifications/presentation/widgets/notification_intent_listener.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/core/theme/theme_controller.dart';
import 'package:dar_care/generated/locale_keys.g.dart';

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
          child: const NotificationIntentListener(
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
      title: LocaleKeys.app_name.tr(),
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
