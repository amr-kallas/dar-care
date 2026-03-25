import 'package:dar_care/features/search/presentation/widgets/promo_banner.dart';
import 'package:dar_care/features/search/presentation/widgets/search_provider_card.dart';
import 'package:dar_care/features/search/presentation/widgets/filter_chip_widget.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                    ), // RTL Back Icon usually forward
                  ),
                  Text(
                    LocaleKeys.search_results_title.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tune, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.right,
                      controller: TextEditingController(
                        text: LocaleKeys.service_cleaning.tr(),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                        ), // Actually layout is LTR so prefix is left...
                        // For RTL feel matching image:
                        suffixIcon: const Icon(Icons.search),
                        prefix: null,
                        filled: true,
                        fillColor: isDark
                            ? AppColors.surfaceDark
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
            ),

            const SizedBox(height: 16),

            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.search_results_found.tr(
                      namedArgs: {'count': '42'},
                    ),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    children: [
                      Text(
                        LocaleKeys.location_riyadh.tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  SearchProviderCard(
                    name: 'Ahmed Al-Saleh',
                    profession: LocaleKeys.profession_pest_control.tr(),
                    rating: '4.9',
                    distance: '2.5 km',
                    imageUrl: 'https://i.pravatar.cc/150?img=12',
                    availabilityText: LocaleKeys.available_now.tr(),
                    isAvailable: true,
                  ),
                  SearchProviderCard(
                    name: 'Mona El-Sayed',
                    profession: LocaleKeys.profession_cleaning.tr(),
                    rating: '4.5',
                    distance: '4.1 km',
                    imageUrl: 'https://i.pravatar.cc/150?img=5',
                    availabilityText: 'Tomorrow 9:00',
                    isAvailable: true, // But scheduled
                  ),

                  const PromoBanner(),

                  SearchProviderCard(
                    name: 'Karim Fouad',
                    profession: LocaleKeys.profession_carpet_cleaning.tr(),
                    rating: '4.2',
                    distance: '6.0 km',
                    imageUrl: 'https://i.pravatar.cc/150?img=8',
                    availabilityText: LocaleKeys.unavailable.tr(),
                    isAvailable: false,
                    isFullyBooked: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
