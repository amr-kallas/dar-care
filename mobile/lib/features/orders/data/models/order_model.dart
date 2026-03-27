class OrderModel {
  final String id;
  final String status;
  final DateTime serviceDate;
  final DateTime? createdAt;
  final String? notes;
  final String? providerId;
  final String? clientId;
  final String? serviceId;
  final String? addressId;
  final DateTime? completedAt;
  final String? providerName;

  const OrderModel({
    required this.id,
    required this.status,
    required this.serviceDate,
    this.createdAt,
    this.notes,
    this.providerId,
    this.clientId,
    this.serviceId,
    this.addressId,
    this.completedAt,
    this.providerName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawServiceDate =
        json['scheduled_at'] ?? json['service_date'] ?? json['created_at'];

    return OrderModel(
      id: (json['id'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      serviceDate: _parseDate(rawServiceDate) ?? DateTime.now(),
      createdAt: _parseDate(json['created_at']),
      notes: json['notes'] as String?,
      providerId: _asString(json['provider_id']),
      clientId: _asString(json['client_id']),
      serviceId: _asString(json['service_id']),
      addressId: _asString(json['address_id']),
      completedAt: _parseDate(json['completed_at']),
      providerName: _extractProviderName(json),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _extractProviderName(Map<String, dynamic> json) {
    final dynamic rawProvider = json['providers'] ?? json['provider'];
    if (rawProvider is Map<String, dynamic>) {
      return _extractNameFromProviderMap(rawProvider);
    }

    if (rawProvider is List && rawProvider.isNotEmpty) {
      final first = rawProvider.first;
      if (first is Map<String, dynamic>) {
        return _extractNameFromProviderMap(first);
      }
    }

    return null;
  }

  static String? _extractNameFromProviderMap(Map<String, dynamic> providerMap) {
    final dynamic rawUser = providerMap['users'] ?? providerMap['user'];

    if (rawUser is Map<String, dynamic>) {
      return _asString(rawUser['full_name']) ?? _asString(rawUser['name']);
    }

    if (rawUser is List && rawUser.isNotEmpty) {
      final first = rawUser.first;
      if (first is Map<String, dynamic>) {
        return _asString(first['full_name']) ?? _asString(first['name']);
      }
    }

    return null;
  }
}
