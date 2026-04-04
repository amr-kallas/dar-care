enum NotificationIntentType {
  chat,
  providerNewOrder,
  clientOrderUpdate,
}

class NotificationIntent {
  const NotificationIntent({
    required this.type,
    this.orderId,
    this.providerId,
    this.clientId,
    this.title,
  });

  final NotificationIntentType type;
  final String? orderId;
  final String? providerId;
  final String? clientId;
  final String? title;
}

