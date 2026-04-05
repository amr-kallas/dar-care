import 'dart:convert';

import 'package:dar_care/core/utils/localized_db_text.dart';

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
  final double? latitude;
  final double? longitude;

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
    this.latitude,
    this.longitude,
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
      latitude: _extractLatitude(json),
      longitude: _extractLongitude(json),
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

    return _asString(json['provider_name']);
  }

  static String? _extractNameFromProviderMap(Map<String, dynamic> providerMap) {
    final dynamic rawUser = providerMap['users'] ?? providerMap['user'];

    if (rawUser is Map<String, dynamic>) {
      return _asString(rawUser['full_name']) ??
          _asString(rawUser['name']) ??
          _asString(providerMap['name']);
    }

    if (rawUser is List && rawUser.isNotEmpty) {
      final first = rawUser.first;
      if (first is Map<String, dynamic>) {
        return _asString(first['full_name']) ??
            _asString(first['name']) ??
            _asString(providerMap['name']);
      }
    }

    return _asString(providerMap['name']);
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

    return _asString(json['client_name']) ?? _asString(json['full_name']);
  }

  static String? _extractNameFromClientMap(Map<String, dynamic> clientMap) {
    final dynamic rawUser = clientMap['users'] ?? clientMap['user'];

    if (rawUser is Map<String, dynamic>) {
      return _asString(rawUser['full_name']) ??
          _asString(rawUser['name']) ??
          _asString(clientMap['name']);
    }

    if (rawUser is List && rawUser.isNotEmpty) {
      final first = rawUser.first;
      if (first is Map<String, dynamic>) {
        return _asString(first['full_name']) ??
            _asString(first['name']) ??
            _asString(clientMap['name']);
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

    if (addressMap != null) {
      final details = _asString(addressMap['details']);
      final cityName = _extractCityName(addressMap);

      if (details != null && cityName != null) {
        return '$details - $cityName';
      }

      final combined = details ?? cityName;
      if (combined != null && combined.trim().isNotEmpty) {
        return combined;
      }
    }

    return _extractAddressFromNotes(_asString(json['notes']));
  }

  static String? _extractCityName(Map<String, dynamic> addressMap) {
    final dynamic rawCity = addressMap['cities'] ?? addressMap['city'];

    if (rawCity is Map<String, dynamic>) {
      return _localizedText(rawCity['name']);
    }

    if (rawCity is List && rawCity.isNotEmpty) {
      final first = rawCity.first;
      if (first is Map<String, dynamic>) {
        return _localizedText(first['name']);
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

    final serviceName = _localizedPayload(serviceMap['name']);

    final category = serviceMap['categories'] ?? serviceMap['category'];
    String? categoryName;
    if (category is Map<String, dynamic>) {
      categoryName = _localizedPayload(category['name']);
    } else if (category is List && category.isNotEmpty) {
      final first = category.first;
      if (first is Map<String, dynamic>) {
        categoryName = _localizedPayload(first['name']);
      }
    }

    return serviceName ?? categoryName;
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

  static double? _extractLatitude(Map<String, dynamic> json) {
    final addressMap = _extractAddressMap(json);
    return _asDouble(addressMap?['current_lat'] ?? addressMap?['lat']);
  }

  static double? _extractLongitude(Map<String, dynamic> json) {
    final addressMap = _extractAddressMap(json);
    // DB uses current_lang as longitude in existing schema.
    return _asDouble(
      addressMap?['current_lng'] ??
          addressMap?['current_lang'] ??
          addressMap?['lng'] ??
          addressMap?['longitude'],
    );
  }

  static Map<String, dynamic>? _extractAddressMap(Map<String, dynamic> json) {
    final dynamic rawAddress = json['addresses'] ?? json['address'];

    if (rawAddress is Map<String, dynamic>) {
      return rawAddress;
    }

    if (rawAddress is List && rawAddress.isNotEmpty) {
      final first = rawAddress.first;
      if (first is Map<String, dynamic>) {
        return first;
      }
    }

    return null;
  }

  static double? _asDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static String? _extractAddressFromNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) {
      return null;
    }

    final lines = notes
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);

    for (final line in lines) {
      final lower = line.toLowerCase();
      if (lower.startsWith('address:')) {
        final value = line.substring('address:'.length).trim();
        if (value.isNotEmpty) {
          return value;
        }
      }
      if (line.startsWith('العنوان:')) {
        final value = line.substring('العنوان:'.length).trim();
        if (value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }

  static String? _localizedText(dynamic value) {
    final resolved = LocalizedDbText.fromSupabase(value).resolve(
      languageCode: 'en',
      fallbackLanguageCode: 'en',
      emptyValue: '',
    );
    return resolved.trim().isEmpty ? null : resolved.trim();
  }

  static String? _localizedPayload(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      return jsonEncode(value);
    }

    if (value is String) {
      final text = value.trim();
      return text.isEmpty ? null : text;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
