class ChatListItem {
  final String id;
  final String providerId;
  final String? providerUserId;
  final String providerName;
  final DateTime? createdAt;

  const ChatListItem({
    required this.id,
    required this.providerId,
    required this.providerUserId,
    required this.providerName,
    required this.createdAt,
  });

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    final provider = _asMap(json['providers']);
    final users = _asMap(provider['users']);

    return ChatListItem(
      id: (json['id'] ?? '').toString(),
      providerId: (json['provider_id'] ?? '').toString(),
      providerUserId: provider['user_id']?.toString(),
      providerName: (users['full_name'] ?? '').toString(),
      createdAt: _parseDate(json['created_at']),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is Map) {
        return Map<String, dynamic>.from(first);
      }
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}

