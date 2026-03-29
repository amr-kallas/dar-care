import 'dart:async';

import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:dar_care/features/location_setup/data/location_setup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/widgets/app_snackbar.dart';

class LocationSetupScreen extends StatefulWidget {
  const LocationSetupScreen({super.key});

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  static const LatLng _fallbackCenter = LatLng(30.0444, 31.2357);

  final LocationSetupService _locationSetupService = LocationSetupService();
  final MapController _mapController = MapController();

  bool _isPreparing = true;
  bool _isSaving = false;
  String? _inlineError;

  String? _userId;
  UserRole _role = UserRole.client;
  LatLng? _selectedPoint;

  @override
  void initState() {
    super.initState();
    unawaited(_prepareFlow());
  }

  Future<void> _prepareFlow() async {
    try {
      final currentUser = SupabaseService.auth.currentUser;
      if (currentUser == null) {
        if (!mounted) return;
        context.go(AppRouter.loginPath);
        return;
      }

      _userId = currentUser.id;
      _role = await _locationSetupService.getCurrentUserRole(currentUser.id);

      final hasSavedLocation = await _locationSetupService.hasSavedLocation(
        userId: currentUser.id,
        role: _role,
      );
      if (hasSavedLocation) {
        if (!mounted) return;
        context.go(AppRouter.homePath);
        return;
      }

      final Position? position = await _requestAndFetchCurrentPosition();

      if (position != null) {
        _selectedPoint = LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      _inlineError = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isPreparing = false;
        });
      }
    }
  }

  Future<Position?> _requestAndFetchCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Please enable location services to continue.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required to continue.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _inlineError = null;
      _isPreparing = true;
    });

    try {
      final position = await _requestAndFetchCurrentPosition();
      if (!mounted) return;
      if (position != null) {
        final point = LatLng(position.latitude, position.longitude);
        setState(() {
          _selectedPoint = point;
        });
        _mapController.move(point, 16);
      }
    } catch (e) {
      setState(() {
        _inlineError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPreparing = false;
        });
      }
    }
  }

  Future<void> _saveAndContinue() async {
    final userId = _userId;
    final point = _selectedPoint;

    if (userId == null || point == null) {
      setState(() {
        _inlineError = 'Please pick a location first.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _inlineError = null;
    });

    try {
      await _locationSetupService.upsertCurrentUserLocation(
        userId: userId,
        role: _role,
        lat: point.latitude,
        lng: point.longitude,
      );

      if (!mounted) return;
      context.go(AppRouter.homePath);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _inlineError = 'Failed to save location. Please try again.';
      });
      AppSnackbar.showError(context, 'Location save failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPoint = _selectedPoint ?? _fallbackCenter;

    return Scaffold(
      appBar: AppBar(title: const Text('Set your location')),
      body: Column(
        children: [
          if (_inlineError != null)
            Container(
              width: double.infinity,
              color: Colors.red.shade50,
              padding: const EdgeInsets.all(12),
              child: Text(
                _inlineError!,
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: selectedPoint,
                    initialZoom: 16,
                    onTap: (_, tappedPoint) {
                      setState(() {
                        _selectedPoint = tappedPoint;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.darcare.mobile',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: selectedPoint,
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
                if (_isPreparing)
                  const ColoredBox(
                    color: Color(0x4D000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _selectedPoint == null
                      ? 'Tap the map to set your location.'
                      : 'Lat: ${selectedPoint.latitude.toStringAsFixed(6)} | '
                            'Lng: ${selectedPoint.longitude.toStringAsFixed(6)}',
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _isPreparing ? null : _useCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Use my current location'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isSaving || _isPreparing
                      ? null
                      : _saveAndContinue,
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm location and continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
