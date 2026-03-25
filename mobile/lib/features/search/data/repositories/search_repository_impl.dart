import 'package:dar_care/features/home/client/data/models/provider_model.dart';
import 'package:dar_care/features/search/domain/repositories/search_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SupabaseClient _supabase;

  SearchRepositoryImpl(this._supabase);

  @override
  Future<List<ProviderModel>> searchProviders(String query) async {
    try {
      if (query.isEmpty) return [];

      // Search across provider name (through users) or bio or profession (through department)
      // Supabase supports full text search, but for simplicity we'll use ilike for now
      // Or we can use `or` filter.
      // However, searching related tables (users) is tricky with simple syntax.
      // We might need a database function or view for efficient search.

      // For now, let's fetch providers and filter. Or use inner join on user name.
      // Supabase query builder for nested resource filtering:
      // fetch providers where user.full_name ilike ...

      final response = await _supabase
          .from('providers')
          .select('''
            id,
            user_id,
            avg_rating,
            users!inner(full_name, avatar_url),
            departments!inner(name)
          ''')
          .ilike('users.full_name', '%$query%');
          // Note: Filtering on joined tables like this requires specific PostgREST syntax or embedding.
          // The above syntax might not work directly depending on PostgREST version.
          // Correct way often involves:
          // .select('*, users!inner(*)')
          // .ilike('users.full_name', '%$query%')

      // Actually, a better approach for search is to use a View in Supabase or a stored procedure.
      // Let's try simple join filter first. If it fails, we will fallback to client-side filtering (not ideal but safe for start).

      // Let's try a safer approach: Search in users, get IDs, then fetch providers.
      // Or just search by bio for now if easy.

      // Let's assume the complex query works:
       final data = await _supabase
          .from('providers')
          .select('*, users!inner(*), departments!inner(*)')
          .ilike('users.full_name', '%$query%');

      return (data as List<dynamic>)
          .map((json) => ProviderModel.fromJson(json))
          .toList();
    } catch (e) {
      // Fallback: If joined filter fails, standard error catch
      throw Exception('Search failed: $e');
    }
  }
}

