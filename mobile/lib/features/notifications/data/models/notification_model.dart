import 'package:dar_care/features/notifications/data/models/notification_payload_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  const NotificationModel({
    this.id,
    this.userId,
    required this.type,
    this.title,
    this.body,
    this.orderId,
    this.providerId,
    this.clientId,
    this.senderId,
    this.chatId,
    this.isRead = false,
    this.createdAt,
  });

  final String? id;
  final String? userId;
  final String type;
  final String? title;
  final String? body;
  final String? orderId;
  final String? providerId;
  final String? clientId;
  final String? senderId;
  final String? chatId;
  final bool isRead;
  final DateTime? createdAt;

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    final payload = NotificationPayloadModel.fromRemoteMessage(message);

    return NotificationModel(
      type: payload.type,
      title: payload.title ?? message.notification?.title,
      body:
          NotificationPayloadModel.readValue(message.data, const ['body']) ??
          message.notification?.body,
      orderId: payload.orderId,
      providerId: payload.providerId,
      clientId: payload.clientId,
      senderId: payload.senderId,
      chatId: payload.chatId,
      isRead: false,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      type: (json['type'] ?? '').toString().trim().toLowerCase(),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      orderId: json['order_id']?.toString(),
      providerId: json['provider_id']?.toString(),
      clientId: json['client_id']?.toString(),
      senderId: json['sender_id']?.toString(),
      chatId: json['chat_id']?.toString(),
      isRead: json['is_read'] == true,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  NotificationPayloadModel toPayloadModel() {
    return NotificationPayloadModel(
      type: type,
      orderId: orderId,
      providerId: providerId,
      clientId: clientId,
      title: title,
      senderId: senderId,
      chatId: chatId,
    );
  }

  Map<String, dynamic> toInsertJson({required String userId}) {
    return <String, dynamic>{
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'order_id': orderId,
      'provider_id': providerId,
      'client_id': clientId,
      'sender_id': senderId,
      'chat_id': chatId,
      'is_read': isRead,
    };
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: type,
      title: title,
      body: body,
      orderId: orderId,
      providerId: providerId,
      clientId: clientId,
      senderId: senderId,
      chatId: chatId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

