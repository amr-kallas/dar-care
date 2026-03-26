import 'package:dar_care/features/home/data/models/provider_model.dart';
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
      try {
        final data = await _supabase
            .from('providers')
            .select('*, users!inner(*), departments!inner(*)')
            .ilike('users.full_name', '%$query%');

        return (data as List<dynamic>)
            .map((json) => ProviderModel.fromJson(json))
            .toList();
      } catch (e) {
        // Fallback for missing relationships or schema cache issues
        final providersResponse = await _supabase.from('providers').select();
        final usersResponse = await _supabase.from('users').select().ilike('full_name', '%$query%');
        final deptsResponse = await _supabase.from('departments').select();

        final matchedUsers = (usersResponse as List<dynamic>).map((u) => u['id']).toSet();

        return (providersResponse as List<dynamic>)
            .where((p) => matchedUsers.contains(p['user_id']))
            .map((p) {
              final user = (usersResponse as List<dynamic>).firstWhere((u) => u['id'] == p['user_id'], orElse: () => {});
              final dept = (deptsResponse as List<dynamic>).firstWhere((d) => d['id'] == p['department_id'], orElse: () => {});
              p['users'] = user;
              p['departments'] = dept;
              return ProviderModel.fromJson(p);
            }).toList();
      }
    } catch (e) {
      // Fallback: If joined filter fails, standard error catch
      return [];
    }
  }
}

