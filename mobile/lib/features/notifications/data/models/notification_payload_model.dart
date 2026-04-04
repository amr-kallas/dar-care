import 'package:dar_care/features/notifications/domain/entities/notification_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPayloadModel {
  const NotificationPayloadModel({
    required this.type,
    this.orderId,
    this.providerId,
    this.clientId,
    this.title,
    this.senderId,
    this.chatId,
  });

  final String type;
  final String? orderId;
  final String? providerId;
  final String? clientId;
  final String? title;
  final String? senderId;
  final String? chatId;

  factory NotificationPayloadModel.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;
    return NotificationPayloadModel(
      type: (data['type'] ?? data['notification_type'] ?? data['event'] ?? '')
          .toString()
          .trim()
          .toLowerCase(),
      orderId: readValue(data, const ['order_id', 'orderId']),
      providerId: readValue(data, const ['provider_id', 'providerId']),
      clientId: readValue(data, const ['client_id', 'clientId']),
      title: readValue(data, const ['title']) ?? message.notification?.title,
      senderId: readValue(data, const ['sender_id', 'senderId']),
      chatId: readValue(data, const ['chat_id', 'chatId']),
    );
  }

  NotificationIntent? toEntity() {
    switch (type) {
      case 'chat':
      case 'chat_message':
      case 'chat_notification':
        if (providerId == null || clientId == null) {
          return null;
        }
        return NotificationIntent(
          type: NotificationIntentType.chat,
          providerId: providerId,
          clientId: clientId,
          title: title,
        );
      case 'new_order':
      case 'provider_new_order':
        if (orderId == null) {
          return null;
        }
        return NotificationIntent(
          type: NotificationIntentType.providerNewOrder,
          orderId: orderId,
        );
      case 'order_update':
      case 'client_order_update':
        return const NotificationIntent(
          type: NotificationIntentType.clientOrderUpdate,
        );
      default:
        return null;
    }
  }

  static String? readValue(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return null;
  }
}

