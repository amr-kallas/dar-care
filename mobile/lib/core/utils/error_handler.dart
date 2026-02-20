import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// Global error handler for the application
class AppErrorHandler {
  /// Initialize error handling
  static void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logError(details.exception, details.stack);
    };
  }

  /// Log error to console/crash reporting service
  static void _logError(Object error, StackTrace? stackTrace) {
    developer.log(
      'Error occurred',
      error: error,
      stackTrace: stackTrace,
      name: 'DarCare',
    );
  }
}
