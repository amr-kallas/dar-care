import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/search/domain/repositories/search_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<List<ProviderModel>> searchProviders(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    try {
      final data = await _supabase
          .from('providers')
          .select('*, users(*), departments(*)')
          .limit(200);

      final providers = (data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(ProviderModel.fromJson)
          .toList(growable: false);

      final keyword = normalizedQuery.toLowerCase();
      return providers
          .where((provider) => _matches(provider, keyword))
          .toList(growable: false);
    } catch (e) {
      throw Exception('Search request failed: $e');
    }
  }

  bool _matches(ProviderModel provider, String keyword) {
    return provider.fullName.toLowerCase().contains(keyword) ||
        provider.profession.toLowerCase().contains(keyword) ||
        (provider.bio?.toLowerCase().contains(keyword) ?? false);
  }
}
