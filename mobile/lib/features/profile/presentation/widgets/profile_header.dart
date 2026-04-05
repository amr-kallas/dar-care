import 'dart:ui' as ui;
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.user, this.imageUrl});

  final AuthUser? user;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = user?.fullName?.trim().isNotEmpty == true
        ? user!.fullName!.trim()
        : user?.email.split('@').first ?? LocaleKeys.profile_title.tr();

    final resolvedImageUrl =
        (imageUrl?.trim().isNotEmpty == true)
            ? imageUrl!.trim()
            : (user?.avatarUrl?.trim().isNotEmpty == true)
            ? user!.avatarUrl!.trim()
            : null;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
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
          child: _ProfileAvatar(imageUrl: resolvedImageUrl),
        ),
        const SizedBox(height: 20),
        Text(
          displayName,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _InfoLine(
          icon: Icons.email_outlined,
          text: user?.email ?? '--',
          isDark: isDark,
          forceLtr: true,
        ),
        if (user?.phone != null && user!.phone!.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          _InfoLine(
            icon: Icons.phone_outlined,
            text: user!.phone!.trim(),
            isDark: isDark,
            forceLtr: true,
          ),
        ],
        const SizedBox(height: 6),
        _InfoLine(
          icon: Icons.badge_outlined,
          text: user?.role.displayName ?? '--',
          isDark: isDark,
        ),
        if (user?.address != null && user!.address!.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          _InfoLine(
            icon: Icons.location_on_outlined,
            text: user!.address!.trim(),
            isDark: isDark,
          ),
        ],
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl?.trim().isNotEmpty == true;

    return CircleAvatar(
      radius: 46,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: 92,
                height: 92,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Assets.images.png.defaultAvatar.image(
                    fit: BoxFit.cover,
                    width: 92,
                    height: 92,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Assets.images.png.defaultAvatar.image(
                    fit: BoxFit.cover,
                    width: 92,
                    height: 92,
                  );
                },
              )
            : Assets.images.png.defaultAvatar.image(
                fit: BoxFit.cover,
                width: 92,
                height: 92,
              ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
    required this.isDark,
    this.forceLtr = false,
  });

  final IconData icon;
  final String text;
  final bool isDark;
  final bool forceLtr;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: TextStyle(
        color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
        fontSize: 14,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
        ),
        const SizedBox(width: 8),
        if (forceLtr)
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: textWidget,
          )
        else
          textWidget,
      ],
    );
  }
}
