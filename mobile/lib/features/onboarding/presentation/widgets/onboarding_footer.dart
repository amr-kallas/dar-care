import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.pageController,
    required this.onNextPressed,
    required this.onSkipPressed,
    required this.itemCount,
    required this.isLastPage,
  });

  final PageController pageController;
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;
  final int itemCount;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modern Page Indicator with gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.lightGrey,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDeepGreen.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SmoothPageIndicator(
              controller: pageController,
              count: itemCount,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: AppColors.primaryDeepGreen,
                dotColor: isDark ? AppColors.borderDark : AppColors.lightGrey,
                expansionFactor: 4,
                spacing: 8,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Modern Next/Start Button with gradient and animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onNextPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isLastPage
                        ? [
                            AppColors.accentPurple,
                            AppColors.accentPurple.withValues(alpha: 0.8),
                          ]
                        : [AppColors.primaryDeepGreen, AppColors.brightGreen],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isLastPage
                                  ? AppColors.accentPurple
                                  : AppColors.primaryDeepGreen)
                              .withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastPage ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isLastPage ? 0.125 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          isLastPage
                              ? Icons.rocket_launch_rounded
                              : Icons.arrow_forward_rounded,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Modern Skip Button
          AnimatedOpacity(
            opacity: isLastPage ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isLastPage ? 0 : 48,
              child: !isLastPage
                  ? TextButton(
                      onPressed: onSkipPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.mediumGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
