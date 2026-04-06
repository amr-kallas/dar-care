import 'package:dar_care/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:dar_care/features/chat/presentation/cubit/chat_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatErrorSnackBarListener extends StatelessWidget {
  const ChatErrorSnackBarListener({
    super.key,
    required this.child,
  });

  final Widget child;

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
      child: child,
    );
  }
}

