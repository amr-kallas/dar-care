import 'package:dar_care/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:dar_care/features/home/client/data/models/provider_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final SupabaseClient _supabase;

  FavoritesRepositoryImpl(this._supabase);

  Future<int> _getClientId() async {
    final clientRes = await _supabase
        .from('clients')
        .select('id')
        .eq('user_id', _supabase.auth.currentUser!.id)
        .single();
    return clientRes['id'];
  }

  @override
  Future<List<ProviderModel>> getFavorites() async {
    try {
      final clientId = await _getClientId();

      final response = await _supabase.from('favorites').select('''
        provider_id,
        providers!inner(
          id,
          user_id,
          avg_rating,
          hourly_rate,
          experience_years,
          bio,
          users!inner(full_name, avatar_url),
          departments!inner(name)
        )
      ''').eq('client_id', clientId);

      return (response as List<dynamic>)
          .map((json) => ProviderModel.fromJson(json['providers']))
          .toList();
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  @override
  Future<void> addFavorite(int providerId) async {
    try {
      final clientId = await _getClientId();
      await _supabase.from('favorites').insert({
        'client_id': clientId,
        'provider_id': providerId,
      });
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(int providerId) async {
    try {
      final clientId = await _getClientId();
      await _supabase
          .from('favorites')
          .delete()
          .eq('client_id', clientId)
          .eq('provider_id', providerId);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }
}

