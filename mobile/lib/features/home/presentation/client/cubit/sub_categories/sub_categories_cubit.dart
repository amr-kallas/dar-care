import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/features/home/domain/repositories/home_repository.dart';
import 'package:dar_care/features/home/presentation/client/cubit/sub_categories/sub_categories_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubCategoriesCubit extends Cubit<SubCategoriesState> {
  final HomeRepository _homeRepository;

  SubCategoriesCubit(this._homeRepository) : super(const SubCategoriesState());

  Future<void> fetchSubCategories(String departmentId) async {
    emit(state.copyWith(status: SubCategoriesStatus.loading, errorMessage: null));
    try {
      final subCategories = await _homeRepository.getSubCategories(departmentId);
      emit(state.copyWith(
        status: SubCategoriesStatus.success,
        subCategories: subCategories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SubCategoriesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

