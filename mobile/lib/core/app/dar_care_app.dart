import 'package:dar_care/core/theme/app_theme.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main application widget
class DarCareApp extends StatelessWidget {
  const DarCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp.router(
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
        themeMode: ThemeMode.system,

        // DevicePreview integration
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
