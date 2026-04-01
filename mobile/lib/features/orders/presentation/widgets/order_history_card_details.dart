import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class OrderHistoryCardDetails extends StatelessWidget {
  const OrderHistoryCardDetails({
    super.key,
    required this.order,
    required this.secondaryTextColor,
    required this.tertiaryTextColor,
  });

  final OrderModel order;
  final Color secondaryTextColor;
  final Color tertiaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                OrderPresentationUtils.formatServiceDate(
                  context,
                  order.serviceDate,
                ),
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
            Icon(SolarLinearIcons.mapPoint, color: tertiaryTextColor, size: 15),
          ],
        ),
      ],
    );
  }
}
