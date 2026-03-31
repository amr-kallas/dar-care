import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/home_repository.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(const HomeState());

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final results = await Future.wait([
        _homeRepository.getServiceCategories(),
        _homeRepository.getTopProviders(),
      ]);

      final categories = results[0] as List<dynamic>; // Ensure type casting
      final providers = results[1] as List<dynamic>;

      emit(
        state.copyWith(
          status: HomeStatus.success,
          categories: categories.cast(),
          topProviders: providers.cast(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
