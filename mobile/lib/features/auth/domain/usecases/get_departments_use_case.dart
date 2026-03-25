import 'package:dar_care/features/auth/data/models/app_department.dart';
import 'package:dar_care/features/auth/domain/repositories/department_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDepartmentsUseCase {
  final DepartmentRepository repository;

  GetDepartmentsUseCase(this.repository);

  Future<List<AppDepartment>> call() {
    return repository.getDepartments();
  }
}

