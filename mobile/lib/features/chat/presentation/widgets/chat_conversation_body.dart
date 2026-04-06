import 'package:dar_care/features/chat/presentation/widgets/chat_composer_section.dart';
import 'package:dar_care/features/chat/presentation/widgets/message_list_widget.dart';
import 'package:flutter/material.dart';

class ChatConversationBody extends StatelessWidget {
  const ChatConversationBody({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: MessageListWidget(currentUserId: currentUserId),
          ),
          ChatComposerSection(currentUserId: currentUserId),
        ],
      ),
    );
  }
}

