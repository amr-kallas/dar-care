import 'dart:async';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/location_permission_utils.dart';
import 'package:dar_care/core/utils/location_setup_error_utils.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/location_setup/presentation/widgets/location_setup_error_banner.dart';
import 'package:dar_care/features/location_setup/presentation/widgets/location_setup_map_view.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class OrderBookingScreen extends StatefulWidget {
  const OrderBookingScreen({super.key, required this.provider});

  final ProviderModel provider;

  @override
  State<OrderBookingScreen> createState() => _OrderBookingScreenState();
}

class _OrderBookingScreenState extends State<OrderBookingScreen> {
  static const LatLng _fallbackCenter = LatLng(30.0444, 31.2357);

  final MapController _mapController = MapController();
  final TextEditingController _notesController = TextEditingController();

  bool _isPreparing = true;
  bool _isSubmitting = false;
  String? _inlineErrorKey;
  LatLng? _selectedPoint;
  DateTime? _scheduledAt;

  @override
  void initState() {
    super.initState();
    unawaited(_prepareInitialLocation());
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _prepareInitialLocation() async {
    setState(() {
      _isPreparing = true;
      _inlineErrorKey = null;
    });

    try {
      final position =
          await LocationPermissionUtils.requestAndFetchCurrentPosition();
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedPoint = LatLng(position.latitude, position.longitude);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _inlineErrorKey = resolveLocationSetupErrorKey(error);
      });
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isPreparing = false;
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    await _prepareInitialLocation();
    final selectedPoint = _selectedPoint;
    if (selectedPoint == null) {
      return;
    }
    _mapController.move(selectedPoint, 16);
  }

  Future<void> _pickScheduledAt() async {
    final now = DateTime.now();
    final initial = _scheduledAt ?? now.add(const Duration(hours: 1));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (pickedTime == null || !mounted) {
      return;
    }

    setState(() {
      _scheduledAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _confirmBooking() async {
    final selectedPoint = _selectedPoint;
    final scheduledAt = _scheduledAt;

    if (selectedPoint == null) {
      setState(() {
        _inlineErrorKey = 'location_setup_error_pick_first';
      });
      return;
    }

    if (scheduledAt == null) {
      AppSnackbar.showError(context, 'Please select a date and time.');
      return;
    }

    if (!scheduledAt.isAfter(DateTime.now())) {
      AppSnackbar.showError(context, 'Scheduled date must be in the future.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _inlineErrorKey = null;
    });

    try {
      final repository = getIt<OrdersRepository>();
      await (repository as dynamic).createBookingOrder(
        providerId: widget.provider.id,
        scheduledAt: scheduledAt,
        notes: _notesController.text.trim(),
        latitude: selectedPoint.latitude,
        longitude: selectedPoint.longitude,
      );

      if (!mounted) {
        return;
      }

      AppSnackbar.showSuccess(context, 'Booking confirmed successfully.');
      context.go(AppRouter.myOrdersPath);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppSnackbar.showError(context, 'Unable to confirm booking right now.');
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String _scheduledAtLabel(BuildContext context) {
    final value = _scheduledAt;
    if (value == null) {
      return 'Select date and time';
    }

    final localizations = MaterialLocalizations.of(context);
    final date = localizations.formatFullDate(value);
    final time = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(value));
    return '$date - $time';
  }

  @override
  Widget build(BuildContext context) {
    final locationText = _selectedPoint == null
        ? 'Tap on the map to confirm your location.'
        : 'Lat: ${_selectedPoint!.latitude.toStringAsFixed(6)}, Lng: ${_selectedPoint!.longitude.toStringAsFixed(6)}';

    return Scaffold(
      appBar: CustomAppBar(title: 'Book ${widget.provider.fullName}'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_inlineErrorKey != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LocationSetupErrorBanner(errorKey: _inlineErrorKey!),
              ),
            SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: LocationSetupMapView(
                  mapController: _mapController,
                  selectedPoint: _selectedPoint,
                  fallbackCenter: _fallbackCenter,
                  isPreparing: _isPreparing,
                  onTap: (tappedPoint) {
                    setState(() {
                      _selectedPoint = tappedPoint;
                      _inlineErrorKey = null;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(locationText),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _isPreparing ? null : _useCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Use current location'),
            ),
            const SizedBox(height: 18),
            Text('Scheduled At', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isSubmitting ? null : _pickScheduledAt,
              icon: const Icon(Icons.schedule),
              label: Text(_scheduledAtLabel(context)),
            ),
            const SizedBox(height: 18),
            Text('Notes', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              enabled: !_isSubmitting,
              maxLines: 4,
              minLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: 'Add details for the provider',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _confirmBooking,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
