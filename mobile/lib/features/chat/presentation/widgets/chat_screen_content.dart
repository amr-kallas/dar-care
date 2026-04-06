import 'package:dar_care/core/utils/chat_presentation_utils.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_conversation_body.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_error_snack_bar_listener.dart';
import 'package:flutter/material.dart';

class ChatScreenContent extends StatelessWidget {
  const ChatScreenContent({
    super.key,
    required this.currentUserId,
    this.title,
  });

  final String currentUserId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ChatErrorSnackBarListener(
      child: Scaffold(
        appBar: CustomAppBar(title: resolveChatTitle(title)),
        body: ChatConversationBody(currentUserId: currentUserId),
      ),
    );
  }
}

