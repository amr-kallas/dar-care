import 'package:dar_care/core/errors/app_exceptions.dart';
import 'package:dar_care/features/auth/data/models/app_department.dart';
import 'package:dar_care/features/auth/domain/entities/department.dart';
import 'package:dar_care/features/auth/domain/repositories/department_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: DepartmentRepository)
class DepartmentRepositoryImpl implements DepartmentRepository {
  DepartmentRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<List<Department>> getDepartments() async {
    try {
      final List<dynamic> data = await _supabase
          .from('departments')
          .select()
          .order('name');

      return data
          .map((e) => AppDepartment.fromJson(e as Map<String, dynamic>))
          .map(
            (department) =>
                Department(id: department.id, nameText: department.nameText),
          )
          .toList();
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to load departments. Please try again.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
