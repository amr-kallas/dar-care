import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/core/utils/location_permission_utils.dart';
import 'package:dar_care/core/utils/location_setup_error_utils.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:dar_care/features/location_setup/data/location_setup_service.dart';
import 'package:latlong2/latlong.dart';

enum LocationSetupPrepareNextStep { stay, goLogin, goHome }

class LocationSetupPrepareResult {
  const LocationSetupPrepareResult({
    required this.nextStep,
    this.userId,
    this.role,
    this.point,
    this.errorKey,
  });

  final LocationSetupPrepareNextStep nextStep;
  final String? userId;
  final UserRole? role;
  final LatLng? point;
  final String? errorKey;
}

class LocationSetupSaveResult {
  const LocationSetupSaveResult({required this.shouldGoHome, this.errorKey});

  final bool shouldGoHome;
  final String? errorKey;
}

class LocationSetupActionsHelper {
  LocationSetupActionsHelper({
    required LocationSetupService locationSetupService,
  }) : _locationSetupService = locationSetupService;

  final LocationSetupService _locationSetupService;

  Future<LocationSetupPrepareResult> prepareFlow() async {
    try {
      final currentUser = SupabaseService.auth.currentUser;
      if (currentUser == null) {
        return const LocationSetupPrepareResult(
          nextStep: LocationSetupPrepareNextStep.goLogin,
        );
      }

      final role = await _locationSetupService.getCurrentUserRole(
        currentUser.id,
      );
      final hasSavedLocation = await _locationSetupService.hasSavedLocation(
        userId: currentUser.id,
        role: role,
      );

      if (hasSavedLocation) {
        return LocationSetupPrepareResult(
          nextStep: LocationSetupPrepareNextStep.goHome,
          userId: currentUser.id,
          role: role,
        );
      }

      final position =
          await LocationPermissionUtils.requestAndFetchCurrentPosition();
      return LocationSetupPrepareResult(
        nextStep: LocationSetupPrepareNextStep.stay,
        userId: currentUser.id,
        role: role,
        point: LatLng(position.latitude, position.longitude),
      );
    } catch (error) {
      return LocationSetupPrepareResult(
        nextStep: LocationSetupPrepareNextStep.stay,
        errorKey: resolveLocationSetupErrorKey(error),
      );
    }
  }

  Future<LocationSetupSaveResult> saveAndContinue({
    required String? userId,
    required UserRole role,
    required LatLng? selectedPoint,
  }) async {
    if (userId == null || selectedPoint == null) {
      return const LocationSetupSaveResult(
        shouldGoHome: false,
        errorKey: 'location_setup_error_pick_first',
      );
    }

    try {
      await _locationSetupService.upsertCurrentUserLocation(
        userId: userId,
        role: role,
        lat: selectedPoint.latitude,
        lng: selectedPoint.longitude,
      );
      return const LocationSetupSaveResult(shouldGoHome: true);
    } catch (_) {
      return const LocationSetupSaveResult(
        shouldGoHome: false,
        errorKey: 'location_setup_error_save_failed',
      );
    }
  }
}
