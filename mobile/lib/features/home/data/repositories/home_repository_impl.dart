import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _supabase;

  HomeRepositoryImpl(this._supabase);

  @override
  Future<List<CategoryModel>> getServiceCategories() async {
    try {
      // Fetching from 'departments' table as main service categories
      final response = await _supabase
          .from('departments')
          .select()
          .order('name');

      return (response as List<dynamic>)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load service categories: $e');
    }
  }

  @override
  Future<List<ProviderModel>> getTopProviders() async {
    try {
      // Attempt to load providers natively.
      // Doing simple select first to check if relation exists.
      // If schema differs or relationship is missing, a fallback is provided.
      try {
        final response = await _supabase.from('providers').select('''
          id,
          user_id,
          avg_rating,
          users!inner(full_name, avatar_url), 
          departments!inner(name)
        ''').order('avg_rating', ascending: false).limit(10);

        return (response as List<dynamic>)
            .map((json) => ProviderModel.fromJson(json))
            .toList();
      } catch (e) {
        // Fallback for missing relationships or schema cache issues
        final providersResponse = await _supabase.from('providers').select('''
          id,
          user_id,
          avg_rating,
          department_id
        ''').order('avg_rating', ascending: false).limit(10);

        // Fetch users manually for these providers
        final usersResponse = await _supabase.from('users').select();
        // Fetch departments manually
        final deptsResponse = await _supabase.from('departments').select();

        return (providersResponse as List<dynamic>).map((p) {
          final user = (usersResponse as List<dynamic>).firstWhere((u) => u['id'] == p['user_id'], orElse: () => {});
          final dept = (deptsResponse as List<dynamic>).firstWhere((d) => d['id'] == p['department_id'], orElse: () => {});
          p['users'] = user;
          p['departments'] = dept;
          return ProviderModel.fromJson(p);
        }).toList();
      }
    } catch (e) {
      // If everything fails, return empty instead of throwing exception to avoid breaking the UI.
      return [];
    }
  }
}
