import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class ClientHomeSearchBar extends StatelessWidget {
  const ClientHomeSearchBar({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRouter.searchResultsPath),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.brightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(SolarLinearIcons.tuning, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AbsorbPointer(
              child: TextField(
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: LocaleKeys.search_hint.tr(),
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: const Icon(SolarLinearIcons.magnifer),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: isDark
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

