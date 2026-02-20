import 'package:easy_localization/easy_localization.dart';
import '../../generated/locale_keys.g.dart';

/// Centralized validation messages for reactive forms
abstract class ValidationMessages {
  /// Email validation messages
  static Map<String, String Function(Object)> get email => {
        'required': (_) => LocaleKeys.validation_required_email.tr(),
        'email': (_) => LocaleKeys.validation_invalid_email.tr(),
      };

  /// Password validation messages
  static Map<String, String Function(Object)> get password => {
        'required': (_) => LocaleKeys.validation_required_password.tr(),
        'minLength': (_) => LocaleKeys.validation_min_password.tr(),
      };

  /// Full name validation messages
  static Map<String, String Function(Object)> get fullName => {
        'required': (_) => LocaleKeys.validation_required_name.tr(),
      };

  /// Phone number validation messages
  static Map<String, String Function(Object)> get phoneNumber => {
        'required': (_) => LocaleKeys.validation_required_phone.tr(),
        'pattern': (_) => LocaleKeys.validation_invalid_phone.tr(),
      };
}
