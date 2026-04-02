import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

String formatChatStartedAt(DateTime? value) {
  if (value == null) {
    return LocaleKeys.chat_started.tr();
  }

  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');

  return LocaleKeys.chat_started_on.tr(
    namedArgs: {
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
    },
  );
}

String resolveChatTitle(String? title) {
  final normalized = title?.trim() ?? '';
  if (normalized.isNotEmpty) {
    return normalized;
  }

  return LocaleKeys.chat_title.tr();
}
