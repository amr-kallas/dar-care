import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/onboarding_model.dart';
import 'wavy_header_clipper.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key, required this.item});

  final OnboardingModel item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Wavy Header with Gradient
        ClipPath(
          clipper: WavyHeaderClipper(),
          child: Container(
            height: size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.primaryDeepGreen, AppColors.surfaceDark]
                    : [
                        AppColors.primaryDeepGreen.withValues(alpha: 0.1),
                        AppColors.lightGreen.withValues(alpha: 0.3),
                      ],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              // Lottie Animation in the wavy header area
              SizedBox(
                height: size.height * 0.45,
                child: Center(
                  child: Hero(
                    tag: ValueKey(item.lottieAsset.keyName),
                    child: Container(
                      height: size.height * 0.35,
                      padding: const EdgeInsets.all(32),
                      child: item.lottieAsset.lottie(
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                  ),
                ),
              ),

              // Text Content with modern styling
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title with gradient shimmer effect
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isDark
                                ? [Colors.white, Colors.white70]
                                : [
                                    AppColors.primaryDeepGreen,
                                    AppColors.accentPurple,
                                  ],
                          ).createShader(bounds),
                          child: Text(
                            item.title,
                            style: textTheme.displayLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Subtitle with better readability
                        Text(
                          item.subtitle,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 15,
                            height: 1.5,
                            letterSpacing: 0.2,
                            color:
                                isDark ? Colors.white70 : AppColors.mediumGrey,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
