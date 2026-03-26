import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(4), // For the green border
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.brightGreen,
                    AppColors.brightGreen.withAlpha(128),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const CircleAvatar(
                radius: 46,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=11',
                ), // Placeholder image
              ),
            ),
            Positioned(
              bottom: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(SolarBoldIcons.checkCircle, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      LocaleKeys.gold_member.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'أحمد العلي',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '+966 55 123 4567',
          style: TextStyle(
            color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
            fontSize: 14,
          ),
          textDirection: ui.TextDirection.ltr, // Keep phone number LTR
        ),
      ],
    );
  }
}
