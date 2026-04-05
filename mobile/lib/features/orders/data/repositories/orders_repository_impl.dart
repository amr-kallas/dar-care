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

      final rows = (response as List<dynamic>).whereType<Map<String, dynamic>>();
      final orders = <OrderModel>[];

      for (final row in rows) {
        final enriched = await _enrichProviderOrderRow(row);
        orders.add(OrderModel.fromJson(enriched));
      }

      return orders;
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

  @override
  Future<OrderModel> getProviderOrderById({required String orderId}) async {
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
          .eq('id', orderId)
          .eq('provider_id', providerId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Order not found.');
      }

      final enriched = await _enrichProviderOrderRow(
        Map<String, dynamic>.from(response),
      );

      return OrderModel.fromJson(enriched);
    } on PostgrestException catch (e) {
      throw Exception('Failed to load order details: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }

  Future<Map<String, dynamic>> _enrichProviderOrderRow(
    Map<String, dynamic> row,
  ) async {
    final enriched = Map<String, dynamic>.from(row);

    final clientId = enriched['client_id']?.toString();
    if (_hasValue(clientId) &&
        (_isMissingRelation(enriched['clients']) ||
            !_hasClientName(enriched['clients']))) {
      final client = await _tryLoadClient(clientId!);
      if (client != null) {
        enriched['clients'] = client;
      }
    }

    final addressId = enriched['address_id']?.toString();
    if (_hasValue(addressId) &&
        (_isMissingRelation(enriched['addresses']) ||
            !_hasAddressDetails(enriched['addresses']))) {
      final address = await _tryLoadAddress(addressId!);
      if (address != null) {
        enriched['addresses'] = address;
      }
    }

    final serviceId = enriched['service_id']?.toString();
    if (_isMissingRelation(enriched['services']) && _hasValue(serviceId)) {
      final service = await _tryLoadService(serviceId!);
      if (service != null) {
        enriched['services'] = service;
      }
    }

    return enriched;
  }

  Future<Map<String, dynamic>?> _tryLoadClient(String clientId) async {
    try {
      final response = await _supabase
          .from('clients')
          .select('id, user_id, address_id, image_url, users(full_name)')
          .eq('id', clientId)
          .maybeSingle();

      if (response is Map<String, dynamic>) {
        final client = Map<String, dynamic>.from(response);
        final hasJoinedUser = _hasUserName(client['users']);
        final userId = client['user_id']?.toString();

        if (!hasJoinedUser && _hasValue(userId)) {
          final user = await _tryLoadUserById(userId!);
          if (user != null) {
            client['users'] = user;
          }
        }

        return client;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _tryLoadAddress(String addressId) async {
    try {
      final response = await _supabase
          .from('addresses')
          .select('id, details, current_lat, current_lang, current_lng, cities(name)')
          .eq('id', addressId)
          .maybeSingle();

      if (response is Map<String, dynamic>) {
        return response;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _tryLoadService(String serviceId) async {
    try {
      final response = await _supabase
          .from('services')
          .select('id, name, categories(name)')
          .eq('id', serviceId)
          .maybeSingle();

      if (response is Map<String, dynamic>) {
        return response;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _tryLoadUserById(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id, full_name')
          .eq('id', userId)
          .maybeSingle();

      if (response is Map<String, dynamic>) {
        return response;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  bool _isMissingRelation(dynamic value) {
    if (value == null) {
      return true;
    }

    if (value is List) {
      return value.isEmpty;
    }

    if (value is Map) {
      return value.isEmpty;
    }

    return false;
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

  bool _hasClientName(dynamic relation) {
    if (relation is Map<String, dynamic>) {
      if (_hasValue(relation['name']?.toString())) {
        return true;
      }
      final users = relation['users'] ?? relation['user'];
      return _hasUserName(users);
    }

    if (relation is List && relation.isNotEmpty) {
      for (final item in relation) {
        if (_hasClientName(item)) {
          return true;
        }
      }
    }

    return false;
  }

  bool _hasUserName(dynamic usersRelation) {
    if (usersRelation is Map<String, dynamic>) {
      return _hasValue(usersRelation['full_name']?.toString()) ||
          _hasValue(usersRelation['name']?.toString());
    }

    if (usersRelation is List && usersRelation.isNotEmpty) {
      for (final item in usersRelation) {
        if (_hasUserName(item)) {
          return true;
        }
      }
    }

    return false;
  }

  bool _hasAddressDetails(dynamic relation) {
    if (relation is Map<String, dynamic>) {
      if (_hasValue(relation['details']?.toString())) {
        return true;
      }

      final city = relation['cities'] ?? relation['city'];
      if (city is Map<String, dynamic>) {
        return _hasValue(city['name']?.toString());
      }
      if (city is List && city.isNotEmpty) {
        for (final item in city) {
          if (item is Map<String, dynamic> && _hasValue(item['name']?.toString())) {
            return true;
          }
        }
      }
    }

    if (relation is List && relation.isNotEmpty) {
      for (final item in relation) {
        if (_hasAddressDetails(item)) {
          return true;
        }
      }
    }

    return false;
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
