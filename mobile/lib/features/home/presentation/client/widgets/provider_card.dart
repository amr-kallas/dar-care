import 'package:dar_care/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'package:dar_care/core/theme/app_colors.dart';

import '../../../../../generated/locale_keys.g.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.name,
    required this.profession,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String profession;
  final double rating;
  final String distance;
  final String imageUrl; // For now placeholder logic
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasProviderImage = imageUrl.trim().isNotEmpty;

    // Card Colors
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : Colors.grey.shade200;

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize
            .min, // Use min to fit content, but outer container constraints might force it.
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.deepDarkGreen
                      : const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.ratingYellow.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      SolarBoldIcons.star,
                      size: 14,
                      color: AppColors.ratingYellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Provider Image (Placeholder Circle)
              Container(
                width: 50, // Slightly smaller image
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: hasProviderImage
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Assets.images.png.defaultAvatar.image(
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Assets.images.png.defaultAvatar.image(
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Reduced spacing
          // Info
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16, // Slightly smaller font
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            profession,
            style: const TextStyle(
              color: AppColors.brightGreen,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                distance,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
              const SizedBox(width: 4),
              const Icon(
                SolarLinearIcons.mapPoint,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),

          const Spacer(), // Use Spacer to push button to bottom if there's extra space, or just SizedBox(height: 12)

          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.deepDarkGreen
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  SolarLinearIcons.heart,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40, // Explicit height for button
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brightGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets
                          .zero, // Remove padding to fit text in smaller height
                    ),
                    child: Text(
                      LocaleKeys.button_book_now.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
