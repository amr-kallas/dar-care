import 'package:dar_care/generated/locale_keys.g.dart';

String resolveHomeErrorMessageKey(Object error) {
  final raw = error.toString().toLowerCase();

  if (raw.contains('service categories') ||
      raw.contains('sub categories') ||
      raw.contains('providers')) {
    return LocaleKeys.home_error_generic;
  }

  return LocaleKeys.home_error_generic;
}
