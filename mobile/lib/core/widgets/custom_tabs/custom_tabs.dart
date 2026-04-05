import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/widgets/custom_tabs/custom_tab_chip.dart';
import 'package:dar_care/core/widgets/custom_tabs/custom_tab_item.dart';
import 'package:flutter/material.dart';

class CustomTabs extends StatelessWidget {
  const CustomTabs({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<CustomTabItem> items;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedIndex = items.indexWhere((item) => item.value == selectedValue);
    final safeSelectedIndex = selectedIndex >= 0 ? selectedIndex : 0;
    final alignmentX = items.length == 1
        ? 0.0
        : -1.0 + (2.0 * safeSelectedIndex / (items.length - 1));

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.72)
              : AppColors.lightGreen.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? AppColors.borderDark.withValues(alpha: 0.78)
                : AppColors.brightGreen.withValues(alpha: 0.18),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              height: 48,
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment(alignmentX, 0),
                    child: FractionallySizedBox(
                      widthFactor: 1 / items.length,
                      heightFactor: 1,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppColors.brightGreen,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brightGreen.withValues(
                                alpha: isDark ? 0.24 : 0.28,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Expanded(
                          child: CustomTabChip(
                            item: items[i],
                            isSelected: items[i].value == selectedValue,
                            onTap: () => onChanged(items[i].value),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
