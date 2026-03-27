import 'package:dar_care/features/home/data/models/provider_model.dart';

abstract class FavoritesRepository {
  Future<List<ProviderModel>> getFavorites();
  Future<void> addFavorite(String providerId);
  Future<void> removeFavorite(String providerId);
}

