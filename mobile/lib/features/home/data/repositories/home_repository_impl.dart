import 'dart:developer';
import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/home/data/models/sub_category_model.dart';
import 'package:dar_care/features/home/domain/entities/provider_dashboard_summary.dart';
import 'package:dar_care/features/home/domain/repositories/home_repository.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _supabase;

  HomeRepositoryImpl(this._supabase);

  @override
  Future<List<CategoryModel>> getServiceCategories() async {
    try {
      // Fetching from 'departments' table as main service categories
      final response = await _supabase
          .from('departments')
          .select()
          .order('name');

      return (response as List<dynamic>)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load service categories: $e');
    }
  }

  @override
  Future<List<SubCategoryModel>> getSubCategories(String departmentId) async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('department_id', departmentId)
          .order('name');

      return (response as List<dynamic>)
          .map((json) => SubCategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load sub categories: $e');
    }
  }

  @override
  Future<List<ProviderModel>> getTopProviders() async {
    try {
      // Attempt to load providers natively.
      // Doing simple select first to check if relation exists.
      // If schema differs or relationship is missing, a fallback is provided.
      try {
        final response = await _supabase
            .from('providers')
            .select('''
          *,
          users!inner (full_name),
          departments (name)
        ''')
            .order('avg_rating', ascending: false)
            .limit(10);

        log('getTopProviders raw response: $response');

        final mapped = (response as List<dynamic>)
            .map((json) => ProviderModel.fromJson(json))
            .toList();

        // If users was returned as null due to RLS, let's trigger fallback
        if (mapped.isNotEmpty &&
            (mapped.first.fullName == 'Unknown Provider' ||
                mapped.first.fullName.isEmpty)) {
          throw Exception('Users returned null, triggering fallback');
        }

        return mapped;
      } catch (e) {
        log('First DB query failed in getTopProviders: $e');
        // Fallback for missing relationships or schema cache issues
        final providersResponse = await _supabase
            .from('providers')
            .select()
            .order('avg_rating', ascending: false)
            .limit(10);

        // Fetch users manually for these providers
        final providerUserIds = (providersResponse as List<dynamic>)
            .map((p) => p['user_id'])
            .toSet()
            .toList();

        log('Fallback fetching users for IDs: $providerUserIds');
        final usersResponse = await _supabase
            .from('users')
            .select()
            .inFilter('id', providerUserIds);
        log('Fallback fetched users: $usersResponse');

        // Fetch departments manually
        final providerDeptIds = providersResponse
            .map((p) => p['department_id'])
            .toSet()
            .toList();
        final deptsResponse = await _supabase
            .from('departments')
            .select()
            .inFilter('id', providerDeptIds);

        return providersResponse.map((p) {
          final userStr = p['user_id'] as String;
          final deptStr = p['department_id'] as String;

          final userMaps = usersResponse as List<dynamic>;
          final deptMaps = deptsResponse as List<dynamic>;

          final user = userMaps.firstWhere(
            (u) => u['id'] == userStr,
            orElse: () => <String, dynamic>{},
          );
          final dept = deptMaps.firstWhere(
            (d) => d['id'] == deptStr,
            orElse: () => <String, dynamic>{},
          );

          log('Fallback matching user: $user for provider userId: $userStr');

          final map = Map<String, dynamic>.from(p);
          map['users'] = user;
          map['departments'] = dept;
          return ProviderModel.fromJson(map);
        }).toList();
      }
    } catch (e) {
      log('Fallback failed entirely in getTopProviders: $e');
      // If everything fails, return empty instead of throwing exception to avoid breaking the UI.
      return [];
    }
  }

  @override
  Future<ProviderDashboardSummary> getProviderDashboardSummary() async {
    final providerRow = await _getCurrentProviderRow();
    final providerId = providerRow['id'].toString();

    final completedOrders = await _supabase
        .from('orders')
        .select('id')
        .eq('provider_id', providerId)
        .eq('status', 'completed');

    final completedOrderIds = (completedOrders as List<dynamic>)
        .map((item) => item['id']?.toString())
        .whereType<String>()
        .toList(growable: false);

    double totalEarnings = 0;
    if (completedOrderIds.isNotEmpty) {
      final paymentsRows = await _supabase
          .from('payments')
          .select('amount')
          .inFilter('order_id', completedOrderIds);

      for (final payment in (paymentsRows as List<dynamic>)) {
        totalEarnings += _toDouble(payment['amount']);
      }
    }

    return ProviderDashboardSummary(
      totalEarnings: totalEarnings,
      completedJobs: completedOrderIds.length,
      averageRating: _toDouble(providerRow['avg_rating']),
      isAvailable: providerRow['is_available'] == true,
    );
  }

  @override
  Future<void> updateProviderAvailability({required bool isAvailable}) async {
    final providerRow = await _getCurrentProviderRow();

    await _supabase
        .from('providers')
        .update({'is_available': isAvailable})
        .eq('id', providerRow['id']);
  }

  @override
  Future<List<OrderModel>> getProviderLatestPendingOrders({int limit = 5}) async {
    final providerRow = await _getCurrentProviderRow();

    final response = await _supabase
        .from('orders')
        .select()
        .eq('provider_id', providerRow['id'])
        .eq('status', 'pending')
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(OrderModel.fromJson)
        .toList(growable: false);
  }

  Future<Map<String, dynamic>> _getCurrentProviderRow() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('You must be signed in to access provider dashboard.');
    }

    final row = await _supabase
        .from('providers')
        .select('id, avg_rating, is_available')
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null || row['id'] == null) {
      throw StateError('Provider profile not found for current user.');
    }

    return Map<String, dynamic>.from(row);
  }

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }
}
