import 'package:flutter/material.dart';

import 'package:dar_care/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    required this.icon,
    required this.label,
    this.imageUrl,
    this.isMore = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? imageUrl;
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
              border: isMore && isDark
                  ? Border.all(color: Colors.white10)
                  : null,
            ),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        padding: const EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.brightGreen,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        icon,
                        color: isMore ? Colors.grey : AppColors.brightGreen,
                        size: 28,
                      ),
                    ),
                  )
                : Icon(
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
