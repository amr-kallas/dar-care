import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/provider_presentation_utils.dart';
import 'package:dar_care/core/widgets/provider_card.dart';
import 'package:dar_care/features/chat/presentation/client/screens/client_chat_screen.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/home/presentation/client/widgets/section_header.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClientHomeProvidersSection extends StatelessWidget {
  const ClientHomeProvidersSection({
    super.key,
    required this.topProviders,
    required this.currentUserId,
    required this.languageCode,
  });

  final List<ProviderModel> topProviders;
  final String? currentUserId;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: LocaleKeys.section_providers_near.tr(),
          actionText: LocaleKeys.see_all.tr(),
          onTap: () =>
              context.push(AppRouter.allProvidersPath, extra: topProviders),
        ),
        const SizedBox(height: 16),
        if (topProviders.isEmpty)
          Center(child: Text(LocaleKeys.home_no_providers_found.tr())),
        if (topProviders.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth * 0.9).clamp(
                280.0,
                360.0,
              );

              return SizedBox(
                height: 188,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, favoritesState) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: topProviders.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final provider = topProviders[index];
                        final isFavorite = favoritesState.favorites.any(
                          (p) => p.id == provider.id,
                        );

                        return ProviderCard(
                          width: cardWidth,
                          margin: EdgeInsets.zero,
                          isCompact: true,
                          hourlyRate: ProviderPresentationUtils.hourlyRateText(
                            provider.hourlyRate,
                          ),
                          name: provider.fullName,
                          profession: provider.professionForLanguage(
                            languageCode,
                          ),
                          rating: provider.rating.toStringAsFixed(1),
                          distance: LocaleKeys.distance_from_you.tr(
                            namedArgs: {
                              'distance':
                                  ProviderPresentationUtils.mockDistanceKm,
                            },
                          ),
                          imageUrl: provider.imageUrl ?? '',
                          availabilityText: LocaleKeys.available_now.tr(),
                          isAvailable: true,
                          isFavorite: isFavorite,
                          onFavoriteTap: () {
                            context.read<FavoritesCubit>().toggleFavorite(
                              provider,
                            );
                          },
                          onTap: () {},
                          onChatTap: currentUserId == null
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ClientChatScreen(
                                        currentUserId: currentUserId!,
                                        providerId: provider.userId,
                                        title: provider.fullName,
                                      ),
                                    ),
                                  );
                                },
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
