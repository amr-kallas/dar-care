import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/data/models/app_city.dart';

/// Lightweight city loader used by signup forms.
class CityRepository {
  Future<List<AppCity>> getCities() async {
    final List<dynamic> data = await SupabaseService.client
        .from('cities')
        .select('id,name')
        .order('name');

    return data
        .map((item) => AppCity.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

