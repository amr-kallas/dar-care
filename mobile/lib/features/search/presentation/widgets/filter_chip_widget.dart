import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    this.isPrimary = false,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isPrimary; // The green filled one
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color textColor;

    if (isPrimary) {
      bgColor = AppColors.brightGreen;
      textColor = Colors.black;
    } else if (isSelected) {
      bgColor = AppColors.brightGreen;
      textColor = Colors.black;
    } else {
      bgColor = isDark ? AppColors.surfaceDark : Colors.grey.shade200;
      textColor = Colors.grey;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
