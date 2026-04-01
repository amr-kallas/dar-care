import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPrimaryIcon;
  final String? trailingText;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.isPrimaryIcon = false,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.transparent : AppColors.cardBorderLight,
          width: 1,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: onTap ?? () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isPrimaryIcon
                ? AppColors.brightGreen
                : (isDark ? Colors.white70 : Colors.black87),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(
                  color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Icon(
              SolarLinearIcons.altArrowRight,
              size: 16,
              color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
            ),
          ],
        ),
      ),
    );
  }
}
