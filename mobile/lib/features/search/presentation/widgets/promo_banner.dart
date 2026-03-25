import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brightGreen.withValues(alpha: 0.8),
            AppColors.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
             width: 50, height: 50,
             decoration: BoxDecoration(
               color: AppColors.brightGreen,
               shape: BoxShape.circle,
               boxShadow: [
                 BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)
               ]
             ),
             child: const Center(child: Text('%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                 decoration: BoxDecoration(
                   color: Colors.white10,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Text(LocaleKeys.promo_special_offer.tr(), style: const TextStyle(color: AppColors.brightGreen, fontSize: 10)),
              ),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.promo_discount_title.tr(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
               const SizedBox(height: 4),
               Text(LocaleKeys.promo_code.tr(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
