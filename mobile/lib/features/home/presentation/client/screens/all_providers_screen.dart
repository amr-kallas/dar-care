import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/core/widgets/provider_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/chat/presentation/client/screens/client_chat_screen.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/core/utils/provider_presentation_utils.dart';

class AllProvidersScreen extends StatelessWidget {
  const AllProvidersScreen({super.key, required this.providers});

  final List<ProviderModel> providers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentUserId = resolveAuthUser(context.read<AuthCubit>().state)?.id;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: CustomAppBar(
        titleWidget: Text(
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
          ? Center(child: Text(LocaleKeys.home_no_providers_found.tr()))
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

                    return ProviderCard(
                      hourlyRate: ProviderPresentationUtils.hourlyRateText(
                        provider.hourlyRate,
                      ),
                      name: provider.fullName,
                      profession: provider.professionForLanguage(
                        context.locale.languageCode,
                      ),
                      rating: provider.rating.toString(),
                      distance: LocaleKeys.distance_from_you.tr(
                        namedArgs: {
                          'distance': ProviderPresentationUtils.mockDistanceKm,
                        },
                      ),
                      imageUrl: provider.imageUrl ?? '',
                      availabilityText: LocaleKeys.available_now.tr(),
                      isAvailable: true, // Mock availability
                      isFavorite: isFavorite,
                      onFavoriteTap: () {
                        context.read<FavoritesCubit>().toggleFavorite(provider);
                      },
                      onTap: currentUserId == null
                          ? null
                          : () => context.push(
                              AppRouter.orderBookingPath,
                              extra: provider,
                            ),
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
                );
              },
            ),
    );
  }
}
