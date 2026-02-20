import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SearchProviderCard extends StatelessWidget {
  const SearchProviderCard({
    super.key,
    required this.name,
    required this.profession,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.availabilityText,
    required this.isAvailable, // true = available, false = busy/fully booked
    this.isFullyBooked = false, // if true, shows Grey "Fully Booked" button
  });

  final String name;
  final String profession;
  final String rating;
  final String distance;
  final String imageUrl;
  final String availabilityText; // e.g., "Available Now" or "Tomorrow 9:00"
  final bool isAvailable;
  final bool isFullyBooked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
         boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              // Like Button
               const Icon(Icons.favorite_border, color: Colors.grey),
               
               const Spacer(),

               Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Text(
                     name,
                     style: theme.textTheme.titleMedium?.copyWith(
                       fontWeight: FontWeight.bold,
                       color: isDark ? Colors.white : Colors.black,
                     ),
                   ),
                   const SizedBox(height: 4),
                   Text(
                     profession,
                     style: const TextStyle(
                       color: AppColors.brightGreen,
                       fontWeight: FontWeight.w500,
                       fontSize: 12,
                     ),
                   ),
                   const SizedBox(height: 8),
                   Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                        if (isAvailable) ...[
                          Text(availabilityText, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(width: 4),
                          const Icon(Icons.access_time_filled, size: 14, color: Colors.grey),
                        ] else ...[
                           Text(availabilityText, style: const TextStyle(color: AppColors.errorRed, fontSize: 11)),
                           const SizedBox(width: 4),
                           const Icon(Icons.block, size: 14, color: AppColors.errorRed),
                        ],
                        const SizedBox(width: 12),
                        Text(distance, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(width: 4),
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                     ],
                   ),
                 ],
               ),
               
               const SizedBox(width: 12),

              // Avatar with Rating
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D9F6F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 10),
                            const SizedBox(width: 2),
                            Text(
                              rating,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
               Container(
                 width: 48,
                 height: 48,
                 decoration: BoxDecoration(
                   color: isDark ? AppColors.deepDarkGreen : Colors.grey.shade100,
                   borderRadius: BorderRadius.circular(14),
                 ),
                 child: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
               ),
               const SizedBox(width: 12),
               Expanded(
                 child: SizedBox(
                   height: 48,
                   child: ElevatedButton(
                     onPressed: isFullyBooked ? null : () {},
                     style: ElevatedButton.styleFrom(
                       backgroundColor: isFullyBooked ? Colors.transparent : AppColors.brightGreen,
                       disabledBackgroundColor: isDark ? AppColors.deepDarkGreen : Colors.grey.shade200,
                       foregroundColor: isFullyBooked ? Colors.grey : Colors.white,
                       elevation: 0,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(24),
                       ),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         if (!isFullyBooked) ...[
                            const Icon(Icons.calendar_month, size: 18),
                            const SizedBox(width: 8),
                         ],
                         Text(
                           isFullyBooked ? LocaleKeys.fully_booked.tr() : LocaleKeys.button_book_now.tr(),
                           style: const TextStyle(fontWeight: FontWeight.bold),
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
