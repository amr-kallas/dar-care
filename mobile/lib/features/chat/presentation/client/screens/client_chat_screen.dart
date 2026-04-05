import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/chat_presentation_utils.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:dar_care/features/chat/presentation/cubit/chat_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_composer_section.dart';
import 'package:dar_care/features/chat/presentation/widgets/message_list_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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
      child: _ClientChatScreenView(
        currentUserId: currentUserId,
        title: title,
      ),
    );
  }
}

class _ClientChatScreenView extends StatelessWidget {
  const _ClientChatScreenView({
    required this.currentUserId,
    this.title,
  });

  final String currentUserId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (_, current) => current is ChatError,
      listener: (context, state) {
        if (state is! ChatError) {
          return;
        }

        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger == null) {
          return;
        }

        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(state.messageKey.tr())),
          );
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: resolveChatTitle(title),
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
      ),
    );
  }
}

