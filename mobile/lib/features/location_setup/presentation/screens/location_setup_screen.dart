import 'dart:async';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/location_setup_actions_helper.dart';
import 'package:dar_care/core/utils/location_permission_utils.dart';
import 'package:dar_care/core/utils/location_setup_error_utils.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:dar_care/features/location_setup/data/location_setup_service.dart';
import 'package:dar_care/features/location_setup/presentation/widgets/location_setup_action_panel.dart';
import 'package:dar_care/features/location_setup/presentation/widgets/location_setup_error_banner.dart';
import 'package:dar_care/features/location_setup/presentation/widgets/location_setup_map_view.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class LocationSetupScreen extends StatefulWidget {
  const LocationSetupScreen({super.key});

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  static const LatLng _fallbackCenter = LatLng(30.0444, 31.2357);

  final LocationSetupService _locationSetupService = LocationSetupService();
  late final LocationSetupActionsHelper _actionsHelper =
      LocationSetupActionsHelper(locationSetupService: _locationSetupService);

  final MapController _mapController = MapController();

  bool _isPreparing = true;
  bool _isSaving = false;
  String? _inlineErrorKey;

  String? _userId;
  UserRole _role = UserRole.client;
  LatLng? _selectedPoint;

  @override
  void initState() {
    super.initState();
    unawaited(_prepareFlow());
  }

  Future<void> _prepareFlow() async {
    final result = await _actionsHelper.prepareFlow();

    if (!mounted) return;

    switch (result.nextStep) {
      case LocationSetupPrepareNextStep.goLogin:
        context.go(AppRouter.loginPath);
        return;
      case LocationSetupPrepareNextStep.goHome:
        context.go(AppRouter.homePath);
        return;
      case LocationSetupPrepareNextStep.stay:
        setState(() {
          _userId = result.userId ?? _userId;
          _role = result.role ?? _role;
          _selectedPoint = result.point ?? _selectedPoint;
          _inlineErrorKey = result.errorKey;
          _isPreparing = false;
        });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _inlineErrorKey = null;
      _isPreparing = true;
    });

    try {
      final position =
          await LocationPermissionUtils.requestAndFetchCurrentPosition();
      if (!mounted) return;

      final point = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedPoint = point;
      });
      _mapController.move(point, 16);
    } catch (e) {
      setState(() {
        _inlineErrorKey = resolveLocationSetupErrorKey(e);
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
    setState(() {
      _isSaving = true;
      _inlineErrorKey = null;
    });

    final result = await _actionsHelper.saveAndContinue(
      userId: _userId,
      role: _role,
      selectedPoint: _selectedPoint,
    );

    if (!mounted) return;

    if (result.shouldGoHome) {
      context.go(AppRouter.homePath);
      return;
    }

    setState(() {
      _inlineErrorKey = result.errorKey;
      _isSaving = false;
    });

    if (result.errorKey == LocaleKeys.location_setup_error_save_failed) {
      AppSnackbar.showError(context, result.errorKey!.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(titleWidget: Text(LocaleKeys.location_setup_title.tr())),
      body: Column(
        children: [
          if (_inlineErrorKey != null)
            LocationSetupErrorBanner(errorKey: _inlineErrorKey!),
          Expanded(
            child: LocationSetupMapView(
              mapController: _mapController,
              selectedPoint: _selectedPoint,
              fallbackCenter: _fallbackCenter,
              isPreparing: _isPreparing,
              onTap: (tappedPoint) {
                setState(() {
                  _selectedPoint = tappedPoint;
                });
              },
            ),
          ),
          LocationSetupActionPanel(
            selectedPoint: _selectedPoint,
            isPreparing: _isPreparing,
            isSaving: _isSaving,
            onUseCurrentLocation: _useCurrentLocation,
            onSaveAndContinue: _saveAndContinue,
          ),
        ],
      ),
    );
  }
}
