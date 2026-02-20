import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    required this.icon,
    required this.label,
    this.isMore = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isMore;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: isMore
                  ? (isDark ? AppColors.surfaceDark : Colors.grey.shade100)
                  : (isDark ? AppColors.surfaceDark : Colors.green.shade50),
              borderRadius: BorderRadius.circular(18),
              border: isMore && isDark ? Border.all(color: Colors.white10) : null,
            ),
            child: Icon(
              icon,
              color: isMore ? Colors.grey : AppColors.brightGreen,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
