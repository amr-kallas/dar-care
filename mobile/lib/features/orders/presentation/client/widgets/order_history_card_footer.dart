import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'order_card_display_mode.dart';

class OrderHistoryCardFooter extends StatelessWidget {
  const OrderHistoryCardFooter({
    super.key,
    required this.orderStatus,
    required this.primaryTextColor,
    this.displayMode = OrderCardDisplayMode.client,
  });

  final String orderStatus;
  final Color primaryTextColor;
  final OrderCardDisplayMode displayMode;

  @override
  Widget build(BuildContext context) {
    final statusColor = OrderPresentationUtils.statusColor(orderStatus);
    final statusText = OrderPresentationUtils.statusLocaleKey(orderStatus).tr();

    return Row(
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.14)
                  : Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              _actionText(orderStatus),
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
    );
  }

  String _actionText(String orderStatus) {
    if (displayMode == OrderCardDisplayMode.provider) {
      return LocaleKeys.orders_action_view_details.tr();
    }

    return OrderPresentationUtils.actionLocaleKey(orderStatus).tr();
  }
}
