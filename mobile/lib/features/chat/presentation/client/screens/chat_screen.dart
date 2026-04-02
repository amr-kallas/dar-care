import 'package:dar_care/features/chat/presentation/client/screens/client_chat_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.providerId,
    this.explicitClientId,
    this.title,
  });

  final String currentUserId;
  final String providerId;
  final String? explicitClientId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ClientChatScreen(
      currentUserId: currentUserId,
      providerId: providerId,
      explicitClientId: explicitClientId,
      title: title,
    );
  }
}
