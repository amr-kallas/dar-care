import 'package:dar_care/core/utils/location_permission_utils.dart';

String resolveLocationSetupErrorKey(
  Object error, {
  String fallbackKey = 'location_setup_error_generic',
}) {
  if (error is LocationSetupException) return error.messageKey;
  return fallbackKey;
}
