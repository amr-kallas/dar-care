import 'package:dar_care/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState());

  Future<void> loadFavorites() async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      final favorites = await _repository.getFavorites();
      emit(state.copyWith(
        status: FavoritesStatus.success,
        favorites: favorites,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoritesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> removeFavorite(String providerId) async {
    // Optimistic update
    final initialFavorites = state.favorites;
    emit(state.copyWith(
      favorites: state.favorites.where((p) => p.id != providerId).toList(),
    ));

    try {
      await _repository.removeFavorite(providerId);
    } catch (e) {
      // Revert if failed
      emit(state.copyWith(
        favorites: initialFavorites,
        errorMessage: e.toString(),
      ));
    }
  }
}

