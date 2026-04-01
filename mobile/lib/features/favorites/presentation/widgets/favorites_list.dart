import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/chat/presentation/screens/chat_screen.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/core/widgets/provider_card.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({
    super.key,
    required this.favorites,
    required this.onRefresh,
    required this.onRemoveFavorite,
  });

  final List<ProviderModel> favorites;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String providerId) onRemoveFavorite;

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
    final languageCode = context.locale.languageCode;
    final currentUserId = _resolveCurrentUserId(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final provider = favorites[index];
          return ProviderCard(
            name: provider.fullName,
            profession: provider.professionForLanguage(languageCode),
            rating: provider.rating.toStringAsFixed(1),
            distance: LocaleKeys.distance_from_you.tr(
              namedArgs: {'distance': '2.0'},
            ),
            imageUrl: provider.imageUrl ?? '',
            hourlyRate: provider.hourlyRate != null
                ? '\$${provider.hourlyRate!.toStringAsFixed(0)}/hr'
                : LocaleKeys.price_on_request.tr(),
            availabilityText: LocaleKeys.available_now.tr(),
            isAvailable: true,
            isFavorite: true,
            onFavoriteTap: () async {
              await onRemoveFavorite(provider.id);
            },
            onTap: () {
              // Navigate to provider details.
            },
            onChatTap: currentUserId == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          currentUserId: currentUserId,
                          providerId: provider.userId,
                          title: provider.fullName,
                        ),
                      ),
                    );
                  },
          );
        },
      ),
    );
  }
}
