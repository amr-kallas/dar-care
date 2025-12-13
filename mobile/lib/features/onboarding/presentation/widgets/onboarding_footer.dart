import 'dart:developer';

import 'package:dar_care/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'animated_next_button.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.pageController,
    required this.onNextPressed,
    required this.itemCount,
    required this.isLastPage,
  });

  final PageController pageController;
  final VoidCallback onNextPressed;
  final int itemCount;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLastPage
              ? const SizedBox(width: 80)
              : TextButton(
                  onPressed: () {
                    log("Skip pressed");
                  },
                  child: const Text('Skip'),
                ),
          // Page Indicator
          SmoothPageIndicator(
            controller: pageController,
            count: itemCount,
            effect: const WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: AppTheme.primaryDeepGreen,
              dotColor: AppTheme.lightGrey,
            ),
          ),

          // Next Button
          AnimatedNextButton(
            onNextPressed: onNextPressed,
            isLastPage: isLastPage,
          ),
        ],
      ),
    );
  }
}
