import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/core/widgets/provider_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/chat/presentation/screens/chat_screen.dart';

class AllProvidersScreen extends StatelessWidget {
  const AllProvidersScreen({super.key, required this.providers});

  final List<ProviderModel> providers;

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentUserId = _resolveCurrentUserId(context);

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

                    final hourlyRateText = provider.hourlyRate != null
                        ? '\$${provider.hourlyRate!.toStringAsFixed(0)}/hr'
                        : LocaleKeys.price_on_request.tr();

                    return ProviderCard(
                      hourlyRate: hourlyRateText,
                      name: provider.fullName,
                      profession: provider.professionForLanguage(
                        context.locale.languageCode,
                      ),
                      rating: provider.rating.toString(),
                      distance: LocaleKeys.distance_from_you.tr(
                        namedArgs: {'distance': '2.5'},
                      ),
                      imageUrl: provider.imageUrl ?? '',
                      availabilityText: LocaleKeys.available_now.tr(),
                      isAvailable: true, // Mock availability
                      isFavorite: isFavorite,
                      onFavoriteTap: () {
                        context.read<FavoritesCubit>().toggleFavorite(provider);
                      },
                      onTap: () {
                        // Navigate to provider details
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
                );
              },
            ),
    );
  }
}
