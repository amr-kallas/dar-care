import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getClientOrders();
  Future<List<OrderModel>> getProviderOrders();
  Future<OrderModel> getProviderOrderById({required String orderId});

  Future<void> createPendingOrderRequest({required String providerId});

  Future<void> createBookingOrder({
    required String providerId,
    required DateTime scheduledAt,
    required double latitude,
    required double longitude,
    String? notes,
  });

  Future<void> createOrder({
    required ProviderModel provider,
    required DateTime serviceDate,
    required String address,
    required String notes,
    String? serviceId,
    String? addressId,
  });

  Future<void> acceptOrderWithQuote({
    required String orderId,
    required double quotePrice,
  });

  Future<void> rejectOrder({required String orderId});
}
