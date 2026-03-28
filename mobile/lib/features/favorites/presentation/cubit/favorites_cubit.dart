import 'package:dar_care/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState());

  bool isFavorite(String providerId) {
    return state.favorites.any((provider) => provider.id == providerId);
  }

  Future<void> loadFavorites() async {
    emit(state.copyWith(status: FavoritesStatus.loading, errorMessage: null));

    try {
      final favorites = await _repository.getFavorites();
      emit(
        state.copyWith(
          status: FavoritesStatus.success,
          favorites: favorites,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addFavorite(ProviderModel provider) async {
    if (isFavorite(provider.id)) {
      return;
    }

    final initialFavorites = state.favorites;
    emit(
      state.copyWith(
        favorites: [provider, ...state.favorites],
        errorMessage: null,
      ),
    );

    try {
      await _repository.addFavorite(provider.id);
    } catch (e) {
      emit(
        state.copyWith(favorites: initialFavorites, errorMessage: e.toString()),
      );
    }
  }

  Future<void> removeFavorite(String providerId) async {
    final initialFavorites = state.favorites;
    emit(
      state.copyWith(
        favorites: state.favorites
            .where((provider) => provider.id != providerId)
            .toList(),
        errorMessage: null,
      ),
    );

    try {
      await _repository.removeFavorite(providerId);
    } catch (e) {
      emit(
        state.copyWith(favorites: initialFavorites, errorMessage: e.toString()),
      );
    }
  }

  Future<void> toggleFavorite(ProviderModel provider) async {
    if (isFavorite(provider.id)) {
      return removeFavorite(provider.id);
    }
    return addFavorite(provider);
  }
}
