import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChatsErrorState extends StatelessWidget {
  const ChatsErrorState({
    super.key,
    required this.onRetry,
  });

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocaleKeys.chats_load_error.tr()),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(LocaleKeys.orders_retry_button.tr()),
          ),
        ],
      ),
    );
  }
}

