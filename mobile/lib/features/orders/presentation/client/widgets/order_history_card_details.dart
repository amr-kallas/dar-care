import 'package:dar_care/core/utils/localized_db_text.dart';
import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'order_card_display_mode.dart';

class OrderHistoryCardDetails extends StatelessWidget {
  const OrderHistoryCardDetails({
    super.key,
    required this.order,
    required this.secondaryTextColor,
    required this.tertiaryTextColor,
    this.displayMode = OrderCardDisplayMode.client,
  });

  final OrderModel order;
  final Color secondaryTextColor;
  final Color tertiaryTextColor;
  final OrderCardDisplayMode displayMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (displayMode == OrderCardDisplayMode.provider) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  _serviceTypeText(context),
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(SolarLinearIcons.widget, color: tertiaryTextColor, size: 14),
            ],
          ),
          const SizedBox(height: 8),
        ],
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
                _locationText(context),
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

  String _serviceTypeText(BuildContext context) {
    final service = LocalizedDbText.fromSupabase(order.serviceType).resolve(
      languageCode: context.locale.languageCode,
      fallbackLanguageCode: 'en',
      emptyValue: '',
    );

    return service.trim().isNotEmpty
        ? service.trim()
        : LocaleKeys.provider_order_not_available.tr();
  }

  String _locationText(BuildContext context) {
    final location = order.locationLabel;
    if (location != null && location.trim().isNotEmpty) {
      return location.trim();
    }

    if (displayMode == OrderCardDisplayMode.client && order.addressId != null) {
      return LocaleKeys.orders_address_label.tr(namedArgs: {'id': order.addressId!});
    }

    return LocaleKeys.orders_no_address.tr();
  }
}
