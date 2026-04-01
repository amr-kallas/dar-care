import 'dart:async';

import 'package:dar_care/core/config/localization_config.dart';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/core/theme/theme_controller.dart';
import 'package:dar_care/core/utils/error_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Initialize all app dependencies and configurations
Future<void> initializeApp() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  // Initialize error handling
  AppErrorHandler.initialize();

  // Initialize Supabase
  await SupabaseService.initialize();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Restore saved app theme
  await ThemeController.instance.initialize();

  // Initialize dependency injection
  await configureDependencies();
}

/// Run the app with proper initialization
Future<void> runDarCareApp(Widget app) async {
  // Initialize all app dependencies
  await initializeApp();

  // Run the app
  runApp(
    EasyLocalization(
      supportedLocales: LocalizationConfig.supportedLocales,
      path: LocalizationConfig.translationsPath,
      fallbackLocale: LocalizationConfig.fallbackLocale,
      saveLocale: true,
      child: app,
    ),
  );
}
