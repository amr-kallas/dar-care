import 'package:flutter/material.dart';

/// Animated text widget with sliding animation
class SlidingText extends StatelessWidget {
  const SlidingText({
    super.key,
    required this.slidingAnimation,
    this.text = 'DarCare',
  });

  final Animation<Offset> slidingAnimation;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slidingAnimation,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Colors.white,
        ),
      ),
    );
  }
}
