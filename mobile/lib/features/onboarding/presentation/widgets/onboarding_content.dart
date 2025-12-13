import 'package:dar_care/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../data/models/onboarding_model.dart';
import 'wavy_header_clipper.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key, required this.item});

  final OnboardingModel item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ClipPath(
          clipper: WavyHeaderClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: AppTheme.lightGreen.withAlpha(51),
            child: Center(
              child: Lottie.asset(
                item.lottieAsset,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Text(
                item.title,
                style: textTheme.displayLarge!.copyWith(
                  color: AppTheme.primaryDeepGreen
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                item.subtitle,
                style: textTheme.bodyLarge!.copyWith(
                  color: AppTheme.accentPurple
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
