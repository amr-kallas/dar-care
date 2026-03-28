import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationSetupService {
  LocationSetupService({SupabaseClient? supabaseClient})
    : _client = supabaseClient ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<UserRole> getCurrentUserRole(String userId) async {
    final Map<String, dynamic> userRow = await _client
        .from('users')
        .select('role')
        .eq('id', userId)
        .single();

    return UserRole.fromString(userRow['role'] as String? ?? 'client');
  }

  Future<bool> hasSavedLocation({
    required String userId,
    required UserRole role,
  }) async {
    final profileRow = await _getRoleProfile(userId: userId, role: role);
    final addressId = profileRow['address_id'] as String?;
    if (addressId == null) return false;

    final Map<String, dynamic>? addressRow = await _client
        .from('addresses')
        .select('current_lat,current_lang')
        .eq('id', addressId)
        .maybeSingle();

    if (addressRow == null) return false;

    return addressRow['current_lat'] != null &&
        addressRow['current_lang'] != null;
  }

  Future<void> upsertCurrentUserLocation({
    required String userId,
    required UserRole role,
    required double lat,
    required double lng,
  }) async {
    final profileRow = await _getRoleProfile(userId: userId, role: role);
    final String roleProfileId = profileRow['id'] as String;
    final String? currentAddressId = profileRow['address_id'] as String?;

    final payload = {
      'current_lat': lat,
      'current_lang': lng,
      'location_updated_at': DateTime.now().toIso8601String(),
    };

    if (currentAddressId != null) {
      await _client
          .from('addresses')
          .update(payload)
          .eq('id', currentAddressId);
      return;
    }

    final addressPayload = <String, dynamic>{
      ...payload,
      'details': 'Captured from mobile map',
      if (role == UserRole.client) 'client_id': roleProfileId,
      if (role == UserRole.provider) 'provider_id': roleProfileId,
    };

    final insertedAddress = await _client
        .from('addresses')
        .insert(addressPayload)
        .select('id')
        .single();

    await _client
        .from(_roleTable(role))
        .update({'address_id': insertedAddress['id']})
        .eq('id', roleProfileId);
  }

  Future<Map<String, dynamic>> _getRoleProfile({
    required String userId,
    required UserRole role,
  }) async {
    return await _client
        .from(_roleTable(role))
        .select('id,address_id')
        .eq('user_id', userId)
        .single();
  }

  String _roleTable(UserRole role) {
    return role == UserRole.provider ? 'providers' : 'clients';
  }
}
