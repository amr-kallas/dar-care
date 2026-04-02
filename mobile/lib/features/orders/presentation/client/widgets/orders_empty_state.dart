import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.brightGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              SolarLinearIcons.clipboardList,
              color: isDark
                  ? AppColors.brightGreen
                  : AppColors.primaryDeepGreen,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.orders_empty_title.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            LocaleKeys.orders_empty_subtitle.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
