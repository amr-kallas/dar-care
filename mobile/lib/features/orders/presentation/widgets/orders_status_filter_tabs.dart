import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = <MapEntry<String, String>>[
      MapEntry(OrderFilterValues.all, LocaleKeys.orders_filter_all.tr()),
      MapEntry(
        OrderFilterValues.pending,
        LocaleKeys.orders_filter_pending.tr(),
      ),
      MapEntry(
        OrderFilterValues.completed,
        LocaleKeys.orders_filter_completed.tr(),
      ),
      MapEntry(
        OrderFilterValues.cancelled,
        LocaleKeys.orders_filter_cancelled.tr(),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map((item) {
              final isSelected = item.key == selectedFilter;

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => onChanged(item.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brightGreen
                          : (isDark ? AppColors.surfaceDark : Colors.white),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.brightGreen
                            : (isDark
                                  ? AppColors.borderDark.withValues(alpha: 0.8)
                                  : Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      item.value,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
