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

  @override
  Future<List<OrderModel>> getProviderOrders() async {
    final providerId = await _getProviderId();

    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            clients(*, users(*)),
            addresses(*, cities(name)),
            services(*, categories(name))
          ''')
          .eq('provider_id', providerId)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Exception('Failed to load provider orders: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load provider orders: $e');
    }
  }

  @override
  Future<void> acceptOrderWithQuote({
    required String orderId,
    required double quotePrice,
  }) async {
    final providerId = await _getProviderId();

    final updatesWithQuote = <Map<String, dynamic>>[
      {'status': 'accepted', 'quoted_price': quotePrice},
      {'status': 'accepted', 'price': quotePrice},
      {'status': 'accepted', 'amount': quotePrice},
    ];

    for (final payload in updatesWithQuote) {
      try {
        await _supabase
            .from('orders')
            .update(payload)
            .eq('id', orderId)
            .eq('provider_id', providerId);
        return;
      } on PostgrestException catch (_) {
        // Try the next known quote column shape.
      }
    }

    await _supabase
        .from('orders')
        .update({'status': 'accepted'})
        .eq('id', orderId)
        .eq('provider_id', providerId);
  }

  @override
  Future<void> rejectOrder({required String orderId}) async {
    final providerId = await _getProviderId();

    await _supabase
        .from('orders')
        .update({'status': 'cancelled'})
        .eq('id', orderId)
        .eq('provider_id', providerId);
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

  Future<String> _getProviderId() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to access provider orders.');
    }

    try {
      final providerRes = await _supabase
          .from('providers')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (providerRes == null || providerRes['id'] == null) {
        throw Exception('Provider profile not found for current user.');
      }

      return providerRes['id'].toString();
    } on PostgrestException catch (e) {
      throw Exception('Failed to resolve provider profile: ${e.message}');
    }
  }
}
