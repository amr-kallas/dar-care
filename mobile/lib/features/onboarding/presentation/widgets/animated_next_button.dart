import 'package:dar_care/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AnimatedNextButton extends StatelessWidget {
  const AnimatedNextButton({
    super.key,
    required this.onNextPressed,
    required this.isLastPage,
  });

  final VoidCallback onNextPressed;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNextPressed,
      child: Container(
        height: 60,
        width: 140,
        decoration: BoxDecoration(
          color: isLastPage ? AppTheme.accentPurple : AppTheme.primaryDeepGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 30,
              child: Text(
                isLastPage ? "Finish" : "Next",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isLastPage ? Alignment.center : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLastPage ? Icons.done : Icons.arrow_forward_ios_rounded,
                  color: isLastPage
                      ? AppTheme.accentPurple
                      : AppTheme.primaryDeepGreen,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
