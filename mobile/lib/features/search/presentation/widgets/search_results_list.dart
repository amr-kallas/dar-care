import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/search/presentation/widgets/search_provider_card.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required this.results,
    required this.languageCode,
  });

  final List<ProviderModel> results;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.select(
      (FavoritesCubit cubit) =>
          cubit.state.favorites.map((item) => item.id).toSet(),
    );

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final provider = results[index];
        final hourlyRateText = provider.hourlyRate != null
            ? '\$${provider.hourlyRate!.toStringAsFixed(0)}'
            : LocaleKeys.price_on_request.tr();

        return SearchProviderCard(
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
          onTap: () {},
        );
      },
    );
  }
}
