import 'package:dar_care/features/auth/domain/usecases/get_departments_use_case.dart';
import 'package:dar_care/features/auth/presentation/cubit/department/department_state.dart';
import 'package:dar_care/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DepartmentCubit extends Cubit<DepartmentState> {
  final GetDepartmentsUseCase getDepartmentsUseCase;

  DepartmentCubit(this.getDepartmentsUseCase)
    : super(const DepartmentInitial());

  Future<void> loadDepartments() async {
    emit(const DepartmentLoading());
    try {
      final departments = await getDepartmentsUseCase();
      emit(DepartmentLoaded(departments));
    } catch (error) {
      emit(DepartmentError(AuthErrorMapper.departments(error)));
    }
  }
}
