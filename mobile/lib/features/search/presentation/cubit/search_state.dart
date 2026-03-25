import 'package:dar_care/features/home/client/data/models/provider_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default([]) List<ProviderModel> results,
    @Default(SearchStatus.initial) SearchStatus status,
    String? errorMessage,
  }) = _SearchState;
}

enum SearchStatus {
  initial,
  loading,
  success,
  failure,
}
