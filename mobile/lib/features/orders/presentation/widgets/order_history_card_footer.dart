import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderHistoryCardFooter extends StatelessWidget {
  const OrderHistoryCardFooter({
    super.key,
    required this.orderStatus,
    required this.primaryTextColor,
  });

  final String orderStatus;
  final Color primaryTextColor;

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
              OrderPresentationUtils.actionLocaleKey(orderStatus).tr(),
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
}
