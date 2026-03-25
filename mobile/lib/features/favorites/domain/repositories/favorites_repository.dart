import 'package:dar_care/features/home/client/data/models/provider_model.dart';

abstract class FavoritesRepository {
  Future<List<ProviderModel>> getFavorites();
  Future<void> addFavorite(int providerId);
  Future<void> removeFavorite(int providerId);
}

