import 'package:dar_care/features/auth/domain/entities/department.dart';
import 'package:dar_care/features/auth/domain/repositories/department_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDepartmentsUseCase {
  final DepartmentRepository _repository;

  GetDepartmentsUseCase(this._repository);

  Future<List<Department>> call() => _repository.getDepartments();
}
