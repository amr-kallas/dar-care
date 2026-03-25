import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTheme {
  /// --- Font Family ---
  static const String _fontFamily = 'PlayfairDisplay';

  /// --- LIGHT THEME DATA ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryDeepGreen,
    scaffoldBackgroundColor: AppColors.offWhite,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDeepGreen,
      secondary: AppColors.accentPurple,
      tertiary: AppColors.oliveBrown,
      surface: AppColors.offWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.offBlack,
      error: AppColors.errorRed,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.offWhite,
      iconTheme: IconThemeData(color: AppColors.offBlack),
      titleTextStyle: TextStyle(
        color: AppColors.offBlack,
        fontSize: 20,
        fontWeight: FontWeight.bold, // 700
        fontFamily: _fontFamily,
      ),
    ),
    textTheme: _lightTextTheme,
    elevatedButtonTheme: _elevatedButtonTheme(
      AppColors.primaryDeepGreen,
      Colors.white,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      borderColor: AppColors.lightGrey,
      focusedBorderColor: AppColors.primaryDeepGreen,
      filled: true,
      fillColor: Colors.white,
    ),
  );

  /// --- DARK THEME DATA ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.lightGreen,
    scaffoldBackgroundColor: AppColors.deepDarkGreen,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.brightGreen,
      secondary: AppColors.accentPurple,
      surface: AppColors.deepDarkGreen,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      error: AppColors.errorRed,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.deepDarkGreen,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
      ),
    ),
    textTheme: _darkTextTheme,
    elevatedButtonTheme: _elevatedButtonTheme(
      AppColors.brightGreen,
      Colors.white,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      borderColor: AppColors.borderDark,
      focusedBorderColor: AppColors.brightGreen,
      filled: true,
      fillColor: AppColors.surfaceDark,
    ),
  );

  /// --- Text Themes ---
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.offBlack,
    ),
    // 700
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.offBlack,
    ),
    // 700
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.offBlack,
    ),
    // 600
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.offBlack,
    ),
    // 400
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.mediumGrey,
    ), // 400
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.borderDark,
    ),
  );

  /// --- Button Theme ---
  static ElevatedButtonThemeData _elevatedButtonTheme(
    Color backgroundColor,
    Color foregroundColor,
  ) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold, // 700
        fontFamily: _fontFamily,
      ),
    ),
  );

  /// --- Input Field Theme ---
  static InputDecorationTheme _inputDecorationTheme({
    required Color borderColor,
    required Color focusedBorderColor,
    bool filled = false,
    Color? fillColor,
  }) => InputDecorationTheme(
    filled: filled,
    fillColor: fillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
    ),
    labelStyle: const TextStyle(color: AppColors.mediumGrey),
    hintStyle: const TextStyle(color: AppColors.mediumGrey),
  );
}
