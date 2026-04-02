import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/home/data/models/sub_category_model.dart';
import 'package:dar_care/features/home/domain/entities/provider_dashboard_summary.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';

abstract class HomeRepository {
  Future<List<CategoryModel>> getServiceCategories();
  Future<List<SubCategoryModel>> getSubCategories(String departmentId);
  Future<List<ProviderModel>> getTopProviders();
  Future<ProviderDashboardSummary> getProviderDashboardSummary();
  Future<void> updateProviderAvailability({required bool isAvailable});
  Future<List<OrderModel>> getProviderLatestPendingOrders({int limit = 5});
}
