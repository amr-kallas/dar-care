import 'package:dar_care/features/home/client/data/models/category_model.dart';
import 'package:dar_care/features/home/client/data/models/provider_model.dart';
import 'package:dar_care/features/home/client/domain/repositories/home_repository.dart';
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
      // Join with users and departments tables
      final response = await _supabase.from('providers').select('''
        id,
        user_id,
        avg_rating,
        users!inner(full_name, avatar_url), 
        departments!inner(name)
      ''').order('avg_rating', ascending: false).limit(10);

      // Note: !inner join ensures we only get providers with valid user/department links

      return (response as List<dynamic>)
          .map((json) => ProviderModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load top providers: $e');
    }
  }
}

