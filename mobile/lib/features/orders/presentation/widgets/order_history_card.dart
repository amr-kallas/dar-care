import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:flutter/material.dart';

import 'order_history_card_details.dart';
import 'order_history_card_footer.dart';
import 'order_history_card_header.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          OrderHistoryCardHeader(
            order: order,
            isDark: isDark,
            primaryTextColor: primaryTextColor,
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? Colors.white12 : Colors.black12, height: 1),
          const SizedBox(height: 12),
          OrderHistoryCardDetails(
            order: order,
            secondaryTextColor: secondaryTextColor,
            tertiaryTextColor: tertiaryTextColor,
          ),
          const SizedBox(height: 14),
          OrderHistoryCardFooter(
            orderStatus: order.status,
            primaryTextColor: primaryTextColor,
          ),
        ],
      ),
    );
  }
}
