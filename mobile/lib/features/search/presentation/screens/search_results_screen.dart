import 'package:dar_care/features/search/presentation/cubit/search_cubit.dart';
import 'package:dar_care/features/search/presentation/cubit/search_state.dart';
import 'package:dar_care/features/search/presentation/widgets/promo_banner.dart';
import 'package:dar_care/features/search/presentation/widgets/search_provider_card.dart';
import 'package:dar_care/features/search/presentation/widgets/filter_chip_widget.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc

import 'package:dar_care/core/di/injection.dart'; // Import Injection

import '../../../../core/theme/app_colors.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Provide search cubit
    return BlocProvider(
      create: (context) => getIt<SearchCubit>(),
      child: const _SearchResultsContent(),
    );
  }
}

class _SearchResultsContent extends StatefulWidget {
  const _SearchResultsContent();

  @override
  State<_SearchResultsContent> createState() => _SearchResultsContentState();
}

class _SearchResultsContentState extends State<_SearchResultsContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Potentially auto-focus or load initial results if search term passed
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                    child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => Navigator.of(context).pop(), // Functional back button
                    ),
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
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.search_hint.tr(),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              context.read<SearchCubit>().search(_searchController.text);
                            },
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.surfaceDark
                            : Colors.white,
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

            // Chips
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

            // Promo Banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: PromoBanner(),
            ),

            const SizedBox(height: 24),

            // Results List
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.status == SearchStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == SearchStatus.failure) {
                     return Center(child: Text('Error: ${state.errorMessage}'));
                  }

                  if (state.results.isEmpty && state.status == SearchStatus.success) {
                    return const Center(child: Text('No results found'));
                  }

                  if (state.status == SearchStatus.initial) {
                      return const Center(child: Text('Type to search providers'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: state.results.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final provider = state.results[index];
                      return SearchProviderCard(
                        name: provider.fullName,
                        profession: provider.profession,
                        rating: provider.rating.toStringAsFixed(1),
                        distance: LocaleKeys.distance_from_you.tr(
                            namedArgs: {'distance': '2.0'} // TODO: Calculate distance
                        ),
                        imageUrl: provider.imageUrl ?? '',
                        hourlyRate: provider.hourlyRate != null
                             ? '\$${provider.hourlyRate}/hr'
                             : LocaleKeys.price_on_request.tr(),
                        availabilityText: LocaleKeys.available_now.tr(), // Mock
                        isAvailable: true, // Mock
                        onTap: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
