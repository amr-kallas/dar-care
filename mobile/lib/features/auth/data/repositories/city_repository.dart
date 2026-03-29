import 'package:dar_care/core/errors/app_exceptions.dart';
import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/data/models/app_city.dart';

/// Lightweight city loader used by signup forms.
class CityRepository {
  Future<List<AppCity>> getCities() async {
    try {
      final List<dynamic> data = await SupabaseService.client
          .from('cities')
          .select('id,name')
          .order('name');

      return data
          .map((item) => AppCity.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to load cities. Please try again.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
