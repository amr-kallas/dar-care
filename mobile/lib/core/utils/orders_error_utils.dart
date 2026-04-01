import 'package:dar_care/generated/locale_keys.g.dart';

String resolveOrdersErrorMessageKey(Object error) {
  final raw = error.toString().toLowerCase();

  if (raw.contains('signed in') || raw.contains('client profile')) {
    return LocaleKeys.orders_error_generic;
  }

  if (raw.contains('failed to load orders')) {
    return LocaleKeys.orders_error_generic;
  }

  if (raw.contains('failed to create order')) {
    return LocaleKeys.orders_error_generic;
  }

  return LocaleKeys.orders_error_generic;
}
