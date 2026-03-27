import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'orders_status_filter_tabs.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusKey = order.status.toLowerCase();
    final statusLocaleKey = statusKey == OrderFilterValues.completed
        ? LocaleKeys.order_status_completed
        : statusKey == OrderFilterValues.cancelled
        ? LocaleKeys.order_status_cancelled
        : statusKey == OrderFilterValues.pending
        ? LocaleKeys.order_status_pending
        : LocaleKeys.order_status_confirmed;
    final statusText = statusLocaleKey.tr();
    final bool isCancelled = statusKey == OrderFilterValues.cancelled;
    final bool isCompleted = statusKey == OrderFilterValues.completed;
    final Color statusColor = isCancelled
        ? const Color(0xFFFF6B6B)
        : (isCompleted ? AppColors.brightGreen : const Color(0xFFFFC94D));

    final Color primaryTextColor = isDark ? Colors.white : Colors.black87;
    final Color secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final Color tertiaryTextColor = isDark ? Colors.white60 : Colors.black45;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF143429), Color(0xFF0E2A20)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
            : const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFF2F8F4)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
        border: Border.all(
          color: isDark
              ? AppColors.borderDark.withValues(alpha: 0.65)
              : Colors.grey.shade300,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
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
                      LocaleKeys.orders_item_subtitle.tr(
                        namedArgs: {'id': order.id},
                      ),
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
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? Colors.white12 : Colors.black12, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  DateFormat('d MMM y - hh:mm a').format(order.serviceDate),
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                SolarLinearIcons.clipboardList,
                color: tertiaryTextColor,
                size: 14,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  order.addressId != null
                      ? LocaleKeys.orders_address_label.tr(
                          namedArgs: {'id': order.addressId!},
                        )
                      : LocaleKeys.orders_no_address.tr(),
                  style: TextStyle(color: tertiaryTextColor, fontSize: 12),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                SolarLinearIcons.mapPoint,
                color: tertiaryTextColor,
                size: 15,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.14)
                        : Colors.black.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    isCancelled
                        ? LocaleKeys.orders_action_view_details.tr()
                        : LocaleKeys.orders_action_repeat.tr(),
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
