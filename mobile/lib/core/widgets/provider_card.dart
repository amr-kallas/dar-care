import 'package:dar_care/gen/assets.gen.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import '../theme/app_colors.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.name,
    required this.profession,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.availabilityText,
    required this.isAvailable, // true = available, false = busy/fully booked
    this.isFullyBooked = false, // if true, shows Grey "Fully Booked" button
    this.hourlyRate,
    this.tag,
    this.width,
    this.margin,
    this.isCompact = false,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onChatTap,
  });

  final String name;
  final String profession;
  final String rating;
  final String distance;
  final String imageUrl;
  final String availabilityText; // e.g., "Available Now" or "Tomorrow 9:00"
  final bool isAvailable;
  final bool isFullyBooked;
  final String? hourlyRate;
  final String? tag;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final bool isCompact;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onChatTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : Colors.grey.shade200;
    final cardPadding = isCompact ? 12.0 : 16.0;
    final actionHeight = isCompact ? 42.0 : 48.0;
    final spacingBeforeActions = isCompact ? 12.0 : 20.0;

    return Container(
      width: width,
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Favorite toggle button
              IconButton(
                onPressed: onFavoriteTap,
                splashRadius: 20,
                icon: Icon(
                  isFavorite ? SolarBoldIcons.heart : SolarLinearIcons.heart,
                  color: isFavorite ? AppColors.errorRed : Colors.grey,
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profession,
                      style: const TextStyle(
                        color: AppColors.brightGreen,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: _AvailabilityRow(
                            isAvailable: isAvailable,
                            availabilityText: availabilityText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: _DistanceRow(distance: distance),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  _ProviderAvatar(imageUrl: imageUrl),
                  Positioned(
                    bottom: -8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D9F6F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              SolarBoldIcons.star,
                              color: Colors.white,
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating,
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
                  ),
                ],
              ),
            ],
          ),
          if (hourlyRate != null || tag != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.deepDarkGreen
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey : Colors.grey.shade700,
                      ),
                    ),
                  ),
                if (hourlyRate != null)
                  Text(
                    hourlyRate!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
              ],
            ),
          ],

          SizedBox(height: spacingBeforeActions),

          Row(
            children: [
              Container(
                width: actionHeight,
                height: actionHeight,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.deepDarkGreen
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  onPressed: onChatTap,
                  splashRadius: 20,
                  icon: const Icon(
                    SolarLinearIcons.chatRoundLine,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: actionHeight,
                  child: ElevatedButton(
                    onPressed: isFullyBooked ? null : onTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: isFullyBooked
                          ? Colors.transparent
                          : AppColors.brightGreen,
                      disabledBackgroundColor: isDark
                          ? AppColors.deepDarkGreen
                          : Colors.grey.shade200,
                      foregroundColor: isFullyBooked
                          ? Colors.grey
                          : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isFullyBooked) ...[
                          const Icon(SolarLinearIcons.calendar, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            isFullyBooked
                                ? LocaleKeys.fully_booked.tr()
                                : LocaleKeys.button_book_now.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
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

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withAlpha(51)),
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Assets.images.png.defaultAvatar.image(
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Assets.images.png.defaultAvatar.image(
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  );
                },
              )
            : Assets.images.png.defaultAvatar.image(
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
      ),
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  final bool isAvailable;
  final String availabilityText;

  const _AvailabilityRow({
    required this.isAvailable,
    required this.availabilityText,
  });

  @override
  Widget build(BuildContext context) {
    if (isAvailable) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              availabilityText,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(SolarLinearIcons.clockCircle, size: 14, color: Colors.grey),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              availabilityText,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(SolarLinearIcons.stopCircle, size: 14, color: AppColors.errorRed),
        ],
      );
    }
  }
}

class _DistanceRow extends StatelessWidget {
  final String distance;

  const _DistanceRow({required this.distance});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            distance,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(SolarLinearIcons.mapPoint, size: 14, color: Colors.grey),
      ],
    );
  }
}
