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
  final String? clientName;
  final String? locationLabel;
  final String? serviceType;
  final String? problemDescription;
  final double? quotedPrice;

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
    this.clientName,
    this.locationLabel,
    this.serviceType,
    this.problemDescription,
    this.quotedPrice,
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
      clientName: _extractClientName(json),
      locationLabel: _extractLocationLabel(json),
      serviceType: _extractServiceType(json),
      problemDescription: _extractProblemDescription(json),
      quotedPrice: _extractQuotedPrice(json),
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

  static String? _extractClientName(Map<String, dynamic> json) {
    final dynamic rawClient = json['clients'] ?? json['client'];
    if (rawClient is Map<String, dynamic>) {
      return _extractNameFromClientMap(rawClient);
    }

    if (rawClient is List && rawClient.isNotEmpty) {
      final first = rawClient.first;
      if (first is Map<String, dynamic>) {
        return _extractNameFromClientMap(first);
      }
    }

    return null;
  }

  static String? _extractNameFromClientMap(Map<String, dynamic> clientMap) {
    final dynamic rawUser = clientMap['users'] ?? clientMap['user'];

    if (rawUser is Map<String, dynamic>) {
      return _asString(rawUser['full_name']) ?? _asString(rawUser['name']);
    }

    if (rawUser is List && rawUser.isNotEmpty) {
      final first = rawUser.first;
      if (first is Map<String, dynamic>) {
        return _asString(first['full_name']) ?? _asString(first['name']);
      }
    }

    return _asString(clientMap['name']);
  }

  static String? _extractLocationLabel(Map<String, dynamic> json) {
    final dynamic rawAddress = json['addresses'] ?? json['address'];

    Map<String, dynamic>? addressMap;
    if (rawAddress is Map<String, dynamic>) {
      addressMap = rawAddress;
    } else if (rawAddress is List && rawAddress.isNotEmpty) {
      final first = rawAddress.first;
      if (first is Map<String, dynamic>) {
        addressMap = first;
      }
    }

    if (addressMap == null) {
      return null;
    }

    final details = _asString(addressMap['details']);
    final cityName = _extractCityName(addressMap);

    if (details != null && cityName != null) {
      return '$details - $cityName';
    }

    return details ?? cityName;
  }

  static String? _extractCityName(Map<String, dynamic> addressMap) {
    final dynamic rawCity = addressMap['cities'] ?? addressMap['city'];

    if (rawCity is Map<String, dynamic>) {
      return _asString(rawCity['name']);
    }

    if (rawCity is List && rawCity.isNotEmpty) {
      final first = rawCity.first;
      if (first is Map<String, dynamic>) {
        return _asString(first['name']);
      }
    }

    return null;
  }

  static String? _extractServiceType(Map<String, dynamic> json) {
    final dynamic rawService = json['services'] ?? json['service'];

    Map<String, dynamic>? serviceMap;
    if (rawService is Map<String, dynamic>) {
      serviceMap = rawService;
    } else if (rawService is List && rawService.isNotEmpty) {
      final first = rawService.first;
      if (first is Map<String, dynamic>) {
        serviceMap = first;
      }
    }

    if (serviceMap == null) {
      return null;
    }

    final category = serviceMap['categories'] ?? serviceMap['category'];
    if (category is Map<String, dynamic>) {
      return _asString(category['name']);
    }

    if (category is List && category.isNotEmpty) {
      final first = category.first;
      if (first is Map<String, dynamic>) {
        return _asString(first['name']);
      }
    }

    return _asString(serviceMap['name']);
  }

  static String? _extractProblemDescription(Map<String, dynamic> json) {
    final dynamic rawService = json['services'] ?? json['service'];

    if (rawService is Map<String, dynamic>) {
      return _asString(rawService['problem_description']) ?? _asString(json['notes']);
    }

    if (rawService is List && rawService.isNotEmpty) {
      final first = rawService.first;
      if (first is Map<String, dynamic>) {
        return _asString(first['problem_description']) ?? _asString(json['notes']);
      }
    }

    return _asString(json['notes']);
  }

  static double? _extractQuotedPrice(Map<String, dynamic> json) {
    final dynamic raw = json['quoted_price'] ?? json['price'] ?? json['amount'];
    if (raw == null) {
      return null;
    }

    if (raw is num) {
      return raw.toDouble();
    }

    return double.tryParse(raw.toString());
  }
}
