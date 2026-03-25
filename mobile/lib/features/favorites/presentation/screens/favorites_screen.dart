import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/search/presentation/widgets/search_provider_card.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/core/di/injection.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FavoritesCubit>()..loadFavorites(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.favorites_screen_placeholder.tr()),
        ),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state.status == FavoritesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == FavoritesStatus.failure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            if (state.favorites.isEmpty) {
              return const Center(child: Text('No favorites yet'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.favorites.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final provider = state.favorites[index];
                return SearchProviderCard(
                  name: provider.fullName,
                  profession: provider.profession,
                  rating: provider.rating.toStringAsFixed(1),
                  distance: LocaleKeys.distance_from_you.tr(
                      namedArgs: {'distance': '2.0'}
                  ),
                  imageUrl: provider.imageUrl ?? '',
                  hourlyRate: provider.hourlyRate != null
                       ? '\$${provider.hourlyRate}/hr'
                       : LocaleKeys.price_on_request.tr(),
                  availabilityText: LocaleKeys.available_now.tr(),
                  isAvailable: true,
                  onTap: () {
                     // Navigate to provider details
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

