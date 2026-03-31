import 'package:dar_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class FavoritesErrorState extends StatelessWidget {
  const FavoritesErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              SolarLinearIcons.dangerCircle,
              color: AppColors.errorRed,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await onRetry();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
