import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class OrdersErrorState extends StatelessWidget {
  const OrdersErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              SolarLinearIcons.dangerCircle,
              color: AppColors.errorRed,
              size: 38,
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.orders_error_title.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message?.trim().isNotEmpty == true
                  ? message!
                  : LocaleKeys.orders_error_generic.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brightGreen,
                foregroundColor: Colors.black,
              ),
              child: Text(LocaleKeys.orders_retry_button.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
