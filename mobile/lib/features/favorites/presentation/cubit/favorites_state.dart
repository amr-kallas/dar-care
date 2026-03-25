import 'package:dar_care/features/home/client/data/models/provider_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_state.freezed.dart';

@freezed
abstract class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default([]) List<ProviderModel> favorites,
    @Default(FavoritesStatus.initial) FavoritesStatus status,
    String? errorMessage,
  }) = _FavoritesState;
}

enum FavoritesStatus {
  initial,
  loading,
  success,
  failure,
}
