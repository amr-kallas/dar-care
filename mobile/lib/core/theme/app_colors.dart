import 'package:flutter/material.dart';

/// Centralized color constants for the app
abstract class AppColors {
  /// Primary colors from palette
  static const Color primaryDeepGreen = Color(0xFF025439);
  static const Color accentPurple = Color(0xFF390255);
  static const Color oliveBrown = Color(0xFF553902);

  /// Supporting palette
  static const Color lightGreen = Color(0xFFA5D6A7);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color lightGrey = Color(0xFFE9ECEF);
  static const Color mediumGrey = Color(0xFF6C757D);
  static const Color offBlack = Color(0xFF212529);

  /// Semantic colors for light theme
  static const Color brightGreen = Color(0xFF2D9F6F);
  static const Color backgroundLight = offWhite;
  static const Color surfaceLight = Colors.white;
  static const Color cardBorderLight = lightGrey;

  /// Semantic colors for dark theme
  static const Color deepDarkGreen = Color(0xFF081C15);
  static const Color surfaceDark = Color(0xFF102923);
  static const Color borderDark = Color(0xFF2D4B42);
  static const Color backgroundDark = deepDarkGreen;

  /// Common colors
  static const Color errorRed = Colors.redAccent;
  static const Color warningOrange = Colors.orange;
  static const Color ratingYellow = Color(0xFFFFC107);
  static const Color successGreen = brightGreen;
}
