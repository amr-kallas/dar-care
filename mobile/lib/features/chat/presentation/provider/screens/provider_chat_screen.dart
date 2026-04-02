import 'package:dar_care/features/chat/presentation/client/screens/client_chat_screen.dart';
import 'package:flutter/material.dart';

class ProviderChatScreen extends StatelessWidget {
  const ProviderChatScreen({
    super.key,
    required this.currentUserId,
    required this.providerId,
    required this.clientId,
    this.title,
  });

  final String currentUserId;
  final String providerId;
  final String clientId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ClientChatScreen(
      currentUserId: currentUserId,
      providerId: providerId,
      explicitClientId: clientId,
      title: title,
    );
  }
}

