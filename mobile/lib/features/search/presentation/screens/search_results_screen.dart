import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/search/presentation/cubit/search_cubit.dart';
import 'package:dar_care/features/search/presentation/cubit/search_state.dart';
import 'package:dar_care/features/search/presentation/widgets/filter_chip_widget.dart';
import 'package:dar_care/features/search/presentation/widgets/promo_banner.dart';
import 'package:dar_care/features/search/presentation/widgets/search_provider_card.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    final query = initialQuery?.trim() ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = getIt<SearchCubit>();
            if (query.isNotEmpty) {
              cubit.search(query);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => getIt<FavoritesCubit>()..loadFavorites(),
        ),
      ],
      child: _SearchResultsContent(initialQuery: query),
    );
  }
}

class _SearchResultsContent extends StatefulWidget {
  const _SearchResultsContent({required this.initialQuery});

  final String initialQuery;

  @override
  State<_SearchResultsContent> createState() => _SearchResultsContentState();
}

class _SearchResultsContentState extends State<_SearchResultsContent> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    context.read<SearchCubit>().search(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final languageCode = context.locale.languageCode;

    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
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
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _submitSearch(),
                        decoration: InputDecoration(
                          hintText: LocaleKeys.search_hint.tr(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _submitSearch,
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
              SingleChildScrollView(
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
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: PromoBanner(),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state.status == SearchStatus.loading) {
                      return const AppLoadingIndicator();
                    }

                    if (state.status == SearchStatus.failure) {
                      return _FailureState(
                        message:
                            state.errorMessage ?? 'Failed to load results.',
                        onRetry: _submitSearch,
                      );
                    }

                    if (state.status == SearchStatus.initial) {
                      return Center(
                        child: Text(
                          LocaleKeys.search_hint.tr(),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (state.results.isEmpty) {
                      return const Center(
                        child: Text(
                          'No providers found for this search.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final favoriteIds = context.select(
                      (FavoritesCubit cubit) =>
                          cubit.state.favorites.map((item) => item.id).toSet(),
                    );

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: state.results.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final provider = state.results[index];
                        final hourlyRateText = provider.hourlyRate != null
                            ? '\$${provider.hourlyRate!.toStringAsFixed(0)}/hr'
                            : LocaleKeys.price_on_request.tr();

                        return SearchProviderCard(
                          name: provider.fullName,
                          profession: provider.professionForLanguage(
                            languageCode,
                          ),
                          rating: provider.rating.toStringAsFixed(1),
                          distance: LocaleKeys.distance_from_you.tr(
                            namedArgs: {'distance': '2.0'},
                          ),
                          imageUrl: provider.imageUrl ?? '',
                          hourlyRate: hourlyRateText,
                          availabilityText: LocaleKeys.available_now.tr(),
                          isAvailable: true,
                          isFavorite: favoriteIds.contains(provider.id),
                          onFavoriteTap: () {
                            context.read<FavoritesCubit>().toggleFavorite(
                              provider,
                            );
                          },
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
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.errorRed,
              size: 30,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
