import 'package:flutter/material.dart';

/// Manages animations for the splash screen
class SplashAnimationController {
  SplashAnimationController({
    required TickerProvider vsync,
    required Duration logoAnimationDuration,
    required Duration textAnimationDuration,
  })  : _logoAnimationController = AnimationController(
          vsync: vsync,
          duration: logoAnimationDuration,
        ),
        _textAnimationController = AnimationController(
          vsync: vsync,
          duration: textAnimationDuration,
        );

  final AnimationController _logoAnimationController;
  final AnimationController _textAnimationController;

  late final Animation<double> logoFadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(_logoAnimationController);

  late final Animation<Offset> textSlidingAnimation = Tween<Offset>(
    begin: const Offset(0, 5),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    ),
  );

  /// Start all animations
  void startAnimations() {
    _logoAnimationController.forward();
    _textAnimationController.forward();
  }

  /// Dispose all animation controllers
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
  }
}
