import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_tabs/custom_tab_item.dart';
import '../../../../../core/widgets/custom_tabs/custom_tabs.dart';

class OrdersStatusFilterTabs extends StatelessWidget {
  const OrdersStatusFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final String selectedFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <CustomTabItem>[
      CustomTabItem(value: OrderFilterValues.all, label: LocaleKeys.orders_filter_all.tr()),
      CustomTabItem(
        value: OrderFilterValues.pending,
        label: LocaleKeys.orders_filter_pending.tr(),
      ),
      CustomTabItem(
        value: OrderFilterValues.completed,
        label: LocaleKeys.orders_filter_completed.tr(),
      ),
      CustomTabItem(
        value: OrderFilterValues.cancelled,
        label: LocaleKeys.orders_filter_cancelled.tr(),
      ),
    ];

    return CustomTabs(
      items: items,
      selectedValue: selectedFilter,
      onChanged: onChanged,
    );
  }
}
