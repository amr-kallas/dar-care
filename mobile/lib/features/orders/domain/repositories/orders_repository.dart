import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getClientOrders();
  Future<void> createOrder({
    required ProviderModel provider,
    required DateTime serviceDate,
    required String address,
    required String notes,
  });
}

