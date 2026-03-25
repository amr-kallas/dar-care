import 'package:dar_care/features/auth/data/models/app_department.dart';

abstract class DepartmentRepository {
  Future<List<AppDepartment>> getDepartments();
}

