import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class OrderHistoryCardHeader extends StatelessWidget {
  const OrderHistoryCardHeader({
    super.key,
    required this.order,
    required this.isDark,
    required this.primaryTextColor,
  });

  final OrderModel order;
  final bool isDark;
  final Color primaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.06),
          ),
          child: Icon(
            SolarBoldIcons.star,
            color: AppColors.ratingYellow,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (order.providerName?.trim().isNotEmpty ?? false)
                    ? order.providerName!.trim()
                    : LocaleKeys.orders_item_title.tr(
                        namedArgs: {'id': order.id},
                      ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.orders_item_subtitle.tr(namedArgs: {'id': order.id}),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.brightGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : AppColors.brightGreen.withValues(alpha: 0.12),
          ),
          child: Icon(
            SolarLinearIcons.widget,
            color: isDark ? Colors.white70 : AppColors.primaryDeepGreen,
          ),
        ),
      ],
    );
  }
}
