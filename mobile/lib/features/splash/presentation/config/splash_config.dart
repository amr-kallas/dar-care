import 'dart:ui';

/// Splash screen configuration constants
class SplashConfig {
  SplashConfig._();

  /// Duration to show the splash screen
  static const Duration splashDuration = Duration(seconds: 5);

  /// Logo animation duration
  static const Duration logoAnimationDuration = Duration(seconds: 1);

  /// Text animation duration
  static const Duration textAnimationDuration = Duration(seconds: 1);

  /// Logo size
  static const double logoSize = 200.0;

  /// Text sliding animation offset
  static const Offset textSlideBegin = Offset(0, 5);
  static const Offset textSlideEnd = Offset.zero;

  /// Logo fade animation values
  static const double logoFadeBegin = 0.0;
  static const double logoFadeEnd = 1.0;
}
