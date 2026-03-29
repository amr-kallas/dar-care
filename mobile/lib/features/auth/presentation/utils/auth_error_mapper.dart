import 'package:dar_care/core/errors/app_exceptions.dart';
import 'package:dar_care/generated/locale_keys.g.dart';

class AuthErrorMapper {
  static String signIn(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_sign_in_failed);

  static String signUpClient(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_sign_up_failed);

  static String signUpProvider(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_provider_sign_up_failed);

  static String signOut(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_sign_out_failed);

  static String session(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_session_failed);

  static String departments(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_departments_failed);

  static String cities(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_cities_failed);

  static String registrationLookups(Object error) =>
      _toKey(error, fallbackKey: LocaleKeys.auth_error_generic);

  static String _toKey(Object error, {required String fallbackKey}) {
    if (error is AppException) {
      final message = error.message.toLowerCase();

      if (message.contains('invalid credentials') ||
          message.contains('invalid login')) {
        return LocaleKeys.auth_error_invalid_credentials;
      }
      if (message.contains('provider account')) {
        return LocaleKeys.auth_error_provider_sign_up_failed;
      }
      if (message.contains('create account')) {
        return LocaleKeys.auth_error_sign_up_failed;
      }
      if (message.contains('sign out')) {
        return LocaleKeys.auth_error_sign_out_failed;
      }
      if (message.contains('departments')) {
        return LocaleKeys.auth_error_departments_failed;
      }
      if (message.contains('cities')) {
        return LocaleKeys.auth_error_cities_failed;
      }
      if (message.contains('current user') || message.contains('session')) {
        return LocaleKeys.auth_error_session_failed;
      }
    }

    return fallbackKey;
  }
}
