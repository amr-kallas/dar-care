import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMine;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bubbleColor =
        isMine ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final textColor = isMine ? colorScheme.onPrimary : colorScheme.onSurface;
    final maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.78;

    return Align(
      alignment:
          isMine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(16),
            topEnd: const Radius.circular(16),
            bottomStart: Radius.circular(isMine ? 16 : 4),
            bottomEnd: Radius.circular(isMine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                _formatTime(timestamp),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
