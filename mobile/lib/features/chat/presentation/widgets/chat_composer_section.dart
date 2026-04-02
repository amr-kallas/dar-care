import 'package:dar_care/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:dar_care/features/chat/presentation/cubit/chat_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatComposerSection extends StatelessWidget {
  const ChatComposerSection({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) =>
          current is ChatLoaded || current is ChatMessageSending,
      builder: (context, state) {
        if (state is ChatLoaded || state is ChatMessageSending) {
          return ChatInputField(
            enabled: true,
            onSend: (text) {
              context.read<ChatCubit>().sendMessage(
                    senderId: currentUserId,
                    text: text,
                  );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

