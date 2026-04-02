import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/chat_presentation_utils.dart';
import 'package:dar_care/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_composer_section.dart';
import 'package:dar_care/features/chat/presentation/widgets/message_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  final String providerId;
  final String? title;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.providerId,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ChatCubit>()
            ..initializeChat(
              clientId: currentUserId,
              providerId: providerId,
            ),
      child: _ChatScreenView(
        currentUserId: currentUserId,
        title: title,
      ),
    );
  }
}

class _ChatScreenView extends StatelessWidget {
  final String currentUserId;
  final String? title;

  const _ChatScreenView({
    required this.currentUserId,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveChatTitle(title)),
        backgroundColor: colorScheme.surface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageListWidget(currentUserId: currentUserId),
            ),
            ChatComposerSection(currentUserId: currentUserId),
          ],
        ),
      ),
    );
  }
}
