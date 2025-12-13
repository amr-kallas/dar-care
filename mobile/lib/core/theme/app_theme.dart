import 'package:flutter/material.dart';

abstract class AppTheme {
  /// --- Font Family ---
  static const String _fontFamily = 'PlayfairDisplay';

  /// --- Core Palette ---
  static const Color primaryDeepGreen = Color(0xFF025439);
  static const Color accentPurple = Color(0xFF390255);
  static const Color oliveBrown = Color(0xFF553902);

  /// --- Supporting Palette ---
  static const Color lightGreen = Color(0xFFA5D6A7);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color lightGrey = Color(0xFFE9ECEF);
  static const Color mediumGrey = Color(0xFF6C757D);
  static const Color offBlack = Color(0xFF212529);

  /// --- LIGHT THEME DATA ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryDeepGreen,
    scaffoldBackgroundColor: offWhite,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.light(
      primary: primaryDeepGreen,
      secondary: accentPurple,
      tertiary: oliveBrown,
      surface: offWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: offBlack,
      error: Colors.redAccent,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: offWhite,
      iconTheme: IconThemeData(color: offBlack),
      titleTextStyle: TextStyle(
        color: offBlack,
        fontSize: 20,
        fontWeight: FontWeight.bold, // 700
        fontFamily: _fontFamily,
      ),
    ),
    textTheme: _lightTextTheme,
    elevatedButtonTheme: _elevatedButtonTheme(primaryDeepGreen, Colors.white),
    inputDecorationTheme: _inputDecorationTheme(
      borderColor: lightGrey,
      focusedBorderColor: primaryDeepGreen,
    ),
  );

  /// --- DARK THEME DATA ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: lightGreen,
    scaffoldBackgroundColor: offBlack,
    fontFamily: _fontFamily,
    colorScheme: ColorScheme.dark(
      primary: lightGreen,
      secondary: accentPurple.withAlpha(204),
      tertiary: oliveBrown.withAlpha(204),
      surface: offBlack,
      onPrimary: offBlack,
      onSecondary: Colors.white,
      onSurface: offWhite,
      error: Colors.red.shade400,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: offBlack,
      iconTheme: IconThemeData(color: offWhite),
      titleTextStyle: TextStyle(
        color: offWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold, // 700
        fontFamily: _fontFamily,
      ),
    ),
    textTheme: _darkTextTheme,
    elevatedButtonTheme: _elevatedButtonTheme(lightGreen, offBlack),
    inputDecorationTheme: _inputDecorationTheme(
      borderColor: mediumGrey,
      focusedBorderColor: lightGreen,
    ),
  );

  /// --- Text Themes ---
  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: offBlack,
    ),
    // 700
    headlineMedium: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: offBlack,
    ),
    // 700
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: offBlack,
    ),
    // 600
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: offBlack,
    ),
    // 400
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: mediumGrey,
    ), // 400
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: offWhite,
    ),
    headlineMedium: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: offWhite,
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: offWhite,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: offWhite,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: lightGrey,
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
  }) => InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
    ),
    labelStyle: const TextStyle(color: mediumGrey),
    hintStyle: const TextStyle(color: mediumGrey),
  );
}
