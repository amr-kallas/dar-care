import 'dart:async';

import 'package:dar_care/core/config/localization_config.dart';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/error_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Initialize all app dependencies and configurations
Future<void> initializeApp() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize error handling
  AppErrorHandler.initialize();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // TODO: Initialize other services (e.g., Firebase, local storage, etc.)
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
      child: app,
    ),
  );
}
