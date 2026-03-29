import 'package:dar_care/features/auth/domain/entities/department.dart';

abstract class DepartmentRepository {
  Future<List<Department>> getDepartments();
}
