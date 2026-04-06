import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientChatScreen extends StatelessWidget {
  const ClientChatScreen({
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
    return BlocProvider(
      create: (_) =>
          getIt<ChatCubit>()
            ..initializeChat(
              clientId: explicitClientId ?? currentUserId,
              providerId: providerId,
            ),
      child: ChatScreenContent(
        currentUserId: currentUserId,
        title: title,
      ),
    );
  }
}
