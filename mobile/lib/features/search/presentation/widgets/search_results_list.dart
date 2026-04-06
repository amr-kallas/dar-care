import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/chats_actions_helper.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/core/widgets/provider_card.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required this.results,
    required this.languageCode,
  });

  final List<ProviderModel> results;
  final String languageCode;

  String? _resolveCurrentUserId(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    return switch (authState) {
      AuthAuthenticated(:final user) => user.id,
      AuthSignInSuccess(:final user) => user.id,
      AuthSignUpSuccess(:final user) => user.id,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.select(
      (FavoritesCubit cubit) =>
          cubit.state.favorites.map((item) => item.id).toSet(),
    );
    final currentUserId = _resolveCurrentUserId(context);
    const actionsHelper = ChatsActionsHelper();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final provider = results[index];
        final hourlyRateText = provider.hourlyRate != null
            ? '\$${provider.hourlyRate!.toStringAsFixed(0)}/hr'
            : LocaleKeys.price_on_request.tr();

        return ProviderCard(
          name: provider.fullName,
          profession: provider.professionForLanguage(languageCode),
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
            context.read<FavoritesCubit>().toggleFavorite(provider);
          },
          onTap: currentUserId == null
              ? null
              : () => context.push(AppRouter.orderBookingPath, extra: provider),
          onChatTap: currentUserId == null
              ? null
              : () => actionsHelper.openClientChat(
                    context: context,
                    currentUserId: currentUserId,
                    providerId: provider.id,
                    title: provider.fullName,
                  ),
        );
      },
    );
  }
}
