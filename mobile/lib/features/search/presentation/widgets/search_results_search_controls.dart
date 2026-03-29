import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class SearchResultsSearchControls extends StatelessWidget {
  const SearchResultsSearchControls({
    super.key,
    required this.controller,
    required this.onSubmitSearch,
  });

  final TextEditingController controller;
  final VoidCallback onSubmitSearch;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(SolarLinearIcons.tuning, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSubmitSearch(),
              decoration: InputDecoration(
                hintText: LocaleKeys.search_hint.tr(),
                suffixIcon: IconButton(
                  icon: const Icon(SolarLinearIcons.magnifer),
                  onPressed: onSubmitSearch,
                ),
                filled: true,
                fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
