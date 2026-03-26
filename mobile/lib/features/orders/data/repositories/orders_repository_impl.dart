import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final SupabaseClient _supabase;

  OrdersRepositoryImpl(this._supabase);

  @override
  Future<List<OrderModel>> getClientOrders() async {
    try {
      final clientRes = await _supabase
          .from('clients')
          .select('id')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .single();

      final clientId = clientRes['id'];

      try {
        final response = await _supabase
            .from('orders')
            .select()
            .eq('client_id', clientId)
            .order('scheduled_at', ascending: false);

        return (response as List<dynamic>)
            .map((json) => OrderModel.fromJson(json))
            .toList();
      } catch (e) {
        // Fallback for missing scheduled_at column or table not existing
        return [];
      }
    } catch (e) {
      // Fallback: Return empty instead of crashing the UI
      return [];
    }
  }

  @override
  Future<void> createOrder({
    required ProviderModel provider,
    required DateTime serviceDate,
    required String address,
    required String notes,
  }) async {
    try {
      final clientRes = await _supabase
          .from('clients')
          .select('id')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .single();
      final clientId = clientRes['id'];

      await _supabase.from('orders').insert({
        'client_id': clientId,
        'provider_id': provider.id,
        'scheduled_at': serviceDate.toIso8601String(),
        'address_id': null, // Need to implement proper address saving based on the schema
        'notes': notes,
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}
