import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<List<OrderModel>> getClientOrders() async {
    final clientId = await _getClientId();

    try {
      final response = await _supabase
          .from('orders')
          .select('*, providers(*, users(*))')
          .eq('client_id', clientId)
          .order('scheduled_at', ascending: false);

      return (response as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Exception('Failed to load orders: ${e.message}');
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
    String? serviceId,
    String? addressId,
  }) async {
    final clientId = await _getClientId();

    final mergedNotes = [
      if (address.trim().isNotEmpty) 'Address: ${address.trim()}',
      if (notes.trim().isNotEmpty) notes.trim(),
    ].join('\n');

    try {
      await _supabase.from('orders').insert({
        'client_id': clientId,
        'provider_id': provider.id,
        'service_id': serviceId,
        'address_id': addressId,
        'scheduled_at': serviceDate.toIso8601String(),
        'notes': mergedNotes.isEmpty ? null : mergedNotes,
        'status': 'pending',
      });
    } on PostgrestException catch (e) {
      throw Exception('Failed to create order: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<String> _getClientId() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to access orders.');
    }

    try {
      final clientRes = await _supabase
          .from('clients')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (clientRes == null || clientRes['id'] == null) {
        throw Exception('Client profile not found for current user.');
      }

      return clientRes['id'].toString();
    } on PostgrestException catch (e) {
      throw Exception('Failed to resolve client profile: ${e.message}');
    }
  }
}
