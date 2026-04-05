import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/core/utils/provider_presentation_utils.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/chat/presentation/client/screens/client_chat_screen.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/core/widgets/provider_card.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    final currentUserId = resolveAuthUser(context.read<AuthCubit>().state)?.id;

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
              namedArgs: {'distance': ProviderPresentationUtils.mockDistanceKm},
            ),
            imageUrl: provider.imageUrl ?? '',
            hourlyRate: ProviderPresentationUtils.hourlyRateText(
              provider.hourlyRate,
            ),
            availabilityText: LocaleKeys.available_now.tr(),
            isAvailable: true,
            isFavorite: true,
            onFavoriteTap: () async {
              await onRemoveFavorite(provider.id);
            },
            onTap: currentUserId == null
                ? null
                : () =>
                      context.push(AppRouter.orderBookingPath, extra: provider),
            onChatTap: currentUserId == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ClientChatScreen(
                          currentUserId: currentUserId,
                          providerId: provider.id,
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
