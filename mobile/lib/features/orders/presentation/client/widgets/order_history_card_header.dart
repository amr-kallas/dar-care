import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/localized_db_text.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'order_card_display_mode.dart';

class OrderHistoryCardHeader extends StatelessWidget {
  const OrderHistoryCardHeader({
    super.key,
    required this.order,
    required this.isDark,
    required this.primaryTextColor,
    this.displayMode = OrderCardDisplayMode.client,
  });

  final OrderModel order;
  final bool isDark;
  final Color primaryTextColor;
  final OrderCardDisplayMode displayMode;

  @override
  Widget build(BuildContext context) {
    final titleText = _titleText(context);

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
                titleText,
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
                _subtitleText(context),
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

  String _titleText(BuildContext context) {
    final preferredName = displayMode == OrderCardDisplayMode.provider
        ? order.clientName
        : order.providerName;

    if (preferredName != null && preferredName.trim().isNotEmpty) {
      return preferredName.trim();
    }

    return LocaleKeys.orders_item_title.tr(namedArgs: {'id': order.id});
  }

  String _subtitleText(BuildContext context) {
    if (displayMode == OrderCardDisplayMode.provider) {
      final service = LocalizedDbText.fromSupabase(order.serviceType).resolve(
        languageCode: context.locale.languageCode,
        fallbackLanguageCode: 'en',
        emptyValue: '',
      );
      if (service.trim().isNotEmpty) {
        return service;
      }
    }

    return LocaleKeys.orders_item_subtitle.tr(namedArgs: {'id': order.id});
  }
}
