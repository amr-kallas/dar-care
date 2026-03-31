import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/search/presentation/widgets/search_provider_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';

import '../../../../../generated/locale_keys.g.dart';

class AllProvidersScreen extends StatelessWidget {
  const AllProvidersScreen({super.key, required this.providers});

  final List<ProviderModel> providers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          LocaleKeys.section_providers_near.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: providers.isEmpty
          ? const Center(child: Text('No providers found'))
          : BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, favoritesState) {
                return ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: providers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    final isFavorite = favoritesState.favorites.any(
                      (p) => p.id == provider.id,
                    );
                    return SearchProviderCard(
                      name: provider.fullName,
                      profession: provider.professionForLanguage(
                        context.locale.languageCode,
                      ),
                      rating: provider.rating.toString(),
                      distance: '2.5 km', // Mock distance
                      imageUrl: provider.imageUrl ?? '',
                      availabilityText: 'Available',
                      isAvailable: true, // Mock availability
                      isFavorite: isFavorite,
                      onFavoriteTap: () {
                        context.read<FavoritesCubit>().toggleFavorite(provider);
                      },
                      onTap: () {
                        // Navigate to provider details
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
