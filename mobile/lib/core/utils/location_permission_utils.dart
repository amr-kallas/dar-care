import 'package:geolocator/geolocator.dart';

class LocationSetupException implements Exception {
  const LocationSetupException(this.messageKey);

  final String messageKey;
}

class LocationPermissionUtils {
  static Future<Position> requestAndFetchCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationSetupException(
        'location_setup_error_enable_services',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationSetupException(
        'location_setup_error_permission_required',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }
}
