import 'package:dar_care/features/search/presentation/widgets/filter_chip_widget.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchResultsFilters extends StatelessWidget {
  const SearchResultsFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          FilterChipWidget(
            label: LocaleKeys.filter_highest_rated.tr(),
            isSelected: true,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          FilterChipWidget(
            label: LocaleKeys.filter_map.tr(),
            isSelected: false,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          FilterChipWidget(
            label: LocaleKeys.filter_list.tr(),
            isSelected: true,
            isPrimary: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
