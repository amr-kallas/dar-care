import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';

abstract class HomeRepository {
  Future<List<CategoryModel>> getServiceCategories();
  Future<List<ProviderModel>> getTopProviders();
}

