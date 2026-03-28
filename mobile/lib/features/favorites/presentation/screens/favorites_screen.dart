import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/favorites/presentation/widgets/favorites_empty_state.dart';
import 'package:dar_care/features/favorites/presentation/widgets/favorites_error_state.dart';
import 'package:dar_care/features/favorites/presentation/widgets/favorites_list.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FavoritesCubit>()..loadFavorites(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.favorites_screen_placeholder.tr()),
        ),
        body: BlocConsumer<FavoritesCubit, FavoritesState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            final message = state.errorMessage;
            if (message == null || message.isEmpty) {
              return;
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          builder: (context, state) {
            final cubit = context.read<FavoritesCubit>();

            if (state.status == FavoritesStatus.loading &&
                state.favorites.isEmpty) {
              return const AppLoadingIndicator();
            }

            if (state.status == FavoritesStatus.failure &&
                state.favorites.isEmpty) {
              return FavoritesErrorState(
                message: state.errorMessage ?? 'Failed to load favorites.',
                onRetry: cubit.loadFavorites,
              );
            }

            if (state.favorites.isEmpty) {
              return const FavoritesEmptyState();
            }

            return FavoritesList(
              favorites: state.favorites,
              onRefresh: cubit.loadFavorites,
              onRemoveFavorite: cubit.removeFavorite,
            );
          },
        ),
      ),
    );
  }
}
