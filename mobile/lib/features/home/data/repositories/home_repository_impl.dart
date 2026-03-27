import 'dart:developer';
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
          *,
          users!inner (full_name),
          departments (name)
        ''').order('avg_rating', ascending: false).limit(10);

        log('getTopProviders raw response: $response');

        final mapped = (response as List<dynamic>)
            .map((json) => ProviderModel.fromJson(json))
            .toList();

        // If users was returned as null due to RLS, let's trigger fallback
        if (mapped.isNotEmpty && (mapped.first.fullName == 'Unknown Provider' || mapped.first.fullName.isEmpty)) {
           throw Exception('Users returned null, triggering fallback');
        }

        return mapped;
      } catch (e) {
        log('First DB query failed in getTopProviders: $e');
        // Fallback for missing relationships or schema cache issues
        final providersResponse = await _supabase.from('providers').select().order('avg_rating', ascending: false).limit(10);

        // Fetch users manually for these providers
        final providerUserIds = (providersResponse as List<dynamic>).map((p) => p['user_id']).toSet().toList();

        log('Fallback fetching users for IDs: $providerUserIds');
        final usersResponse = await _supabase.from('users').select().inFilter('id', providerUserIds);
        log('Fallback fetched users: $usersResponse');

        // Fetch departments manually
        final providerDeptIds = providersResponse.map((p) => p['department_id']).toSet().toList();
        final deptsResponse = await _supabase.from('departments').select().inFilter('id', providerDeptIds);

        return providersResponse.map((p) {
          final userStr = p['user_id'] as String;
          final deptStr = p['department_id'] as String;

          final userMaps = usersResponse as List<dynamic>;
          final deptMaps = deptsResponse as List<dynamic>;

          final user = userMaps.firstWhere(
              (u) => u['id'] == userStr,
              orElse: () => <String, dynamic>{});
          final dept = deptMaps.firstWhere(
              (d) => d['id'] == deptStr,
              orElse: () => <String, dynamic>{});

          log('Fallback matching user: $user for provider userId: $userStr');

          final map = Map<String, dynamic>.from(p);
          map['users'] = user;
          map['departments'] = dept;
          return ProviderModel.fromJson(map);
        }).toList();
      }
    } catch (e) {
      log('Fallback failed entirely in getTopProviders: $e');
      // If everything fails, return empty instead of throwing exception to avoid breaking the UI.
      return [];
    }
  }
}
