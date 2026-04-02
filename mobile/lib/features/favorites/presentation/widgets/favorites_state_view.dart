import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/favorites/presentation/widgets/favorites_empty_state.dart';
import 'package:dar_care/features/favorites/presentation/widgets/favorites_error_state.dart';
import 'package:dar_care/features/favorites/presentation/widgets/favorites_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesStateView extends StatelessWidget {
  const FavoritesStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final cubit = context.read<FavoritesCubit>();

        if (state.status == FavoritesStatus.loading &&
            state.favorites.isEmpty) {
          return const AppLoadingIndicator();
        }

        if (state.status == FavoritesStatus.failure &&
            state.favorites.isEmpty) {
          return FavoritesErrorState(
            messageKey: state.errorMessage,
            onRetry: cubit.loadFavorites,
          );
        }

        if (state.status == FavoritesStatus.success &&
            state.favorites.isEmpty) {
          return const FavoritesEmptyState();
        }

        return FavoritesList(
          favorites: state.favorites,
          onRefresh: () async {
            await cubit.loadFavorites();
          },
          onRemoveFavorite: (providerId) async {
            final provider = state.favorites.firstWhere(
              (p) => p.id == providerId,
            );
            await cubit.toggleFavorite(provider);
          },
        );
      },
    );
  }
}
