import 'package:dar_care/features/search/domain/repositories/search_repository.dart';
import 'package:dar_care/features/search/presentation/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repository;

  SearchCubit(this._repository) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(const SearchState()); // Reset
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final results = await _repository.searchProviders(query);
      emit(state.copyWith(
        status: SearchStatus.success,
        results: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

