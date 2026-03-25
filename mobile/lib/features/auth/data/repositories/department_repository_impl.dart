import 'package:dar_care/features/auth/data/models/app_department.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:dar_care/features/auth/domain/repositories/department_repository.dart';

@LazySingleton(as: DepartmentRepository)
class DepartmentRepositoryImpl implements DepartmentRepository {
  DepartmentRepositoryImpl(this._supabase);
  final SupabaseClient _supabase;
  @override
  Future<List<AppDepartment>> getDepartments() async {
    try {
      final List<dynamic> data = await _supabase
          .from('departments')
          .select()
          .order('name');
      return data.map((e) => AppDepartment.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load departments: $e');
    }
  }
}
