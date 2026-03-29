import 'package:dar_care/core/errors/app_exceptions.dart';

class ErrorMessageMapper {
  static String toMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Something went wrong. Please try again.';
  }
}
