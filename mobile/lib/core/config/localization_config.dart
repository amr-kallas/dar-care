import 'package:flutter/material.dart';

/// Configuration for app localization
abstract class LocalizationConfig {
  /// Supported locales for the application
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  /// Path to translation files
  static const String translationsPath = 'assets/translations';

  /// Default/fallback locale
  static const Locale fallbackLocale = Locale('ar');
}
