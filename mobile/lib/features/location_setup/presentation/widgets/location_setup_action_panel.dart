import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationSetupActionPanel extends StatelessWidget {
  const LocationSetupActionPanel({
    super.key,
    required this.selectedPoint,
    required this.isPreparing,
    required this.isSaving,
    required this.onUseCurrentLocation,
    required this.onSaveAndContinue,
  });

  final LatLng? selectedPoint;
  final bool isPreparing;
  final bool isSaving;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onSaveAndContinue;

  @override
  Widget build(BuildContext context) {
    final locationText = selectedPoint == null
        ? 'location_setup_tap_to_set'.tr()
        : 'location_setup_coordinates'.tr(
            namedArgs: {
              'lat': selectedPoint!.latitude.toStringAsFixed(6),
              'lng': selectedPoint!.longitude.toStringAsFixed(6),
            },
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(locationText),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: isPreparing ? null : onUseCurrentLocation,
            icon: const Icon(Icons.my_location),
            label: Text('location_setup_use_current_location'.tr()),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: isSaving || isPreparing ? null : onSaveAndContinue,
            child: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('location_setup_confirm_continue'.tr()),
          ),
        ],
      ),
    );
  }
}
