import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationSetupMapView extends StatelessWidget {
  const LocationSetupMapView({
    super.key,
    required this.mapController,
    required this.selectedPoint,
    required this.fallbackCenter,
    required this.isPreparing,
    required this.onTap,
  });

  final MapController mapController;
  final LatLng? selectedPoint;
  final LatLng fallbackCenter;
  final bool isPreparing;
  final ValueChanged<LatLng> onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: selectedPoint ?? fallbackCenter,
            initialZoom: 16,
            onTap: (_, tappedPoint) => onTap(tappedPoint),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.darcare.mobile',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: selectedPoint ?? fallbackCenter,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (isPreparing)
          const ColoredBox(
            color: Color(0x4D000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
