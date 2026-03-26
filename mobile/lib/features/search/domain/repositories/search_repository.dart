import 'package:dar_care/features/home/data/models/provider_model.dart'; // Reuse Home model for now

abstract class SearchRepository {
  Future<List<ProviderModel>> searchProviders(String query);
}

