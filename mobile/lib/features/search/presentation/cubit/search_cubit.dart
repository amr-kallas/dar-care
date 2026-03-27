import 'package:dar_care/features/search/domain/repositories/search_repository.dart';
import 'package:dar_care/features/search/presentation/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchState());

  final SearchRepository _repository;
  int _latestRequestId = 0;

  Future<void> search(String query) async {
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      emit(const SearchState());
      return;
    }

    final requestId = ++_latestRequestId;
    emit(state.copyWith(status: SearchStatus.loading, errorMessage: null));

    try {
      final results = await _repository.searchProviders(normalizedQuery);
      if (requestId != _latestRequestId) {
        return;
      }

      emit(
        state.copyWith(
          status: SearchStatus.success,
          results: results,
          errorMessage: null,
        ),
      );
    } catch (e) {
      if (requestId != _latestRequestId) {
        return;
      }

      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
          results: const [],
        ),
      );
    }
  }
}
