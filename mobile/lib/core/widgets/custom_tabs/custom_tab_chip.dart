import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/widgets/custom_tabs/custom_tab_item.dart';
import 'package:flutter/material.dart';

class CustomTabChip extends StatelessWidget {
  const CustomTabChip({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final CustomTabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            style: baseStyle.copyWith(
              color: isSelected
                  ? Colors.black.withValues(alpha: 0.88)
                  : (isDark ? Colors.white70 : AppColors.primaryDeepGreen),
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.1,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

