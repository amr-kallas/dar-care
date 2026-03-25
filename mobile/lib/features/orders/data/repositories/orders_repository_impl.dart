import 'package:dar_care/features/home/client/data/models/provider_model.dart';
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
      // Assuming a 'clients' table entry exists for the user.
      // Or we can query by joining if policies allow.
      // But the policies we set up use auth.uid() = clients.user_id.

      // So first we need the client_id for this user.
      final clientRes = await _supabase
          .from('clients')
          .select('id')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .single();

      final clientId = clientRes['id'];

      final response = await _supabase
          .from('orders')
          .select()
          .eq('client_id', clientId)
          .order('service_date', ascending: false);

      return (response as List<dynamic>)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load orders: $e');
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
        'service_date': serviceDate.toIso8601String(),
        'address': address,
        'notes': notes,
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}

