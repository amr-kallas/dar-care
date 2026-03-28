import 'package:dar_care/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final SupabaseClient _supabase;

  FavoritesRepositoryImpl(this._supabase);

  String _requireUserId() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('You must be signed in to manage favorites.');
    }
    return userId;
  }

  Future<String> _getClientId() async {
    final userId = _requireUserId();

    final clientRes = await _supabase
        .from('clients')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (clientRes == null || clientRes['id'] == null) {
      throw StateError('Client profile not found for the current user.');
    }

    return clientRes['id'].toString();
  }

  bool _shouldUseFallback(PostgrestException error) {
    final message = error.message.toLowerCase();
    return error.code == '42703' ||
        message.contains('relationship') ||
        message.contains('schema cache') ||
        message.contains('does not exist');
  }

  Future<List<ProviderModel>> _getFavoritesWithFallback(String clientId) async {
    final favoritesRes = await _supabase
        .from('favorites')
        .select('provider_id')
        .eq('client_id', clientId);

    final providerIds = (favoritesRes as List<dynamic>)
        .map((item) => item['provider_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    if (providerIds.isEmpty) {
      return const [];
    }

    final providersResponse = await _supabase
        .from('providers')
        .select(
          'id,user_id,avg_rating,experience_years,bio,image_url,department_id',
        )
        .inFilter('id', providerIds);

    final providers = (providersResponse as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    final userIds = providers
        .map((provider) => provider['user_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    final departmentIds = providers
        .map((provider) => provider['department_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    final usersResponse = userIds.isEmpty
        ? const <dynamic>[]
        : await _supabase
              .from('users')
              .select('id,full_name')
              .inFilter('id', userIds);

    final departmentsResponse = departmentIds.isEmpty
        ? const <dynamic>[]
        : await _supabase
              .from('departments')
              .select('id,name')
              .inFilter('id', departmentIds);

    final usersById = <String, Map<String, dynamic>>{
      for (final user in usersResponse)
        user['id'].toString(): Map<String, dynamic>.from(user as Map),
    };

    final departmentsById = <String, Map<String, dynamic>>{
      for (final department in departmentsResponse)
        department['id'].toString(): Map<String, dynamic>.from(
          department as Map,
        ),
    };

    return providers.map((provider) {
      final merged = Map<String, dynamic>.from(provider);
      merged['users'] = usersById[provider['user_id']?.toString()] ?? const {};
      merged['departments'] =
          departmentsById[provider['department_id']?.toString()] ?? const {};
      return ProviderModel.fromJson(merged);
    }).toList();
  }

  @override
  Future<List<ProviderModel>> getFavorites() async {
    final clientId = await _getClientId();

    try {
      final response = await _supabase
          .from('favorites')
          .select('''
          provider_id,
          providers!inner(
            id,
            user_id,
            avg_rating,
            experience_years,
            bio,
            image_url,
            department_id,
            users!inner(id, full_name),
            departments!inner(id, name)
          )
        ''')
          .eq('client_id', clientId);

      return (response as List<dynamic>)
          .map((item) => item['providers'])
          .whereType<Map<String, dynamic>>()
          .map(ProviderModel.fromJson)
          .toList();
    } on PostgrestException catch (error) {
      if (_shouldUseFallback(error)) {
        try {
          return await _getFavoritesWithFallback(clientId);
        } on PostgrestException catch (fallbackError) {
          throw Exception('Failed to load favorites: ${fallbackError.message}');
        }
      }
      throw Exception('Failed to load favorites: ${error.message}');
    }
  }

  @override
  Future<void> addFavorite(String providerId) async {
    try {
      final clientId = await _getClientId();
      await _supabase.from('favorites').insert({
        'client_id': clientId,
        'provider_id': providerId,
      });
    } on PostgrestException catch (error) {
      // Ignore duplicate records if a unique constraint already protects rows.
      if (error.code == '23505') {
        return;
      }
      throw Exception('Failed to add favorite: ${error.message}');
    }
  }

  @override
  Future<void> removeFavorite(String providerId) async {
    try {
      final clientId = await _getClientId();
      await _supabase
          .from('favorites')
          .delete()
          .eq('client_id', clientId)
          .eq('provider_id', providerId);
    } on PostgrestException catch (error) {
      throw Exception('Failed to remove favorite: ${error.message}');
    }
  }
}
