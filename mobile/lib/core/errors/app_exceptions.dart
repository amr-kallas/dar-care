/// Base exception type used across app layers.
abstract class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => message;
}

class AuthAppException extends AppException {
  const AuthAppException(super.message, {super.cause, super.stackTrace});
}

class DataAppException extends AppException {
  const DataAppException(super.message, {super.cause, super.stackTrace});
}
