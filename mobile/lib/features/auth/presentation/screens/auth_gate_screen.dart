import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/auth_registration_data_loader.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/features/auth/data/repositories/city_repository.dart';
import 'package:dar_care/features/auth/domain/usecases/get_departments_use_case.dart';
import 'package:dar_care/features/auth/presentation/models/auth_registration_data.dart';
import 'package:dar_care/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_gate_intro_section.dart';
import '../widgets/auth_gate_roles_section.dart';
import '../widgets/auth_text_link_row.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  final AuthRegistrationDataLoader _registrationDataLoader =
      AuthRegistrationDataLoader(
        cityRepository: CityRepository(),
        getDepartmentsUseCase: getIt<GetDepartmentsUseCase>(),
      );
  late final Future<AuthRegistrationData> _registrationDataFuture;

  AuthGateRole? _activeRole;

  @override
  void initState() {
    super.initState();
    _registrationDataFuture = _preloadRegistrationData();
  }

  Future<AuthRegistrationData> _preloadRegistrationData() async {
    try {
      return await _registrationDataLoader.load();
    } catch (error) {
      throw _PreloadException(AuthErrorMapper.registrationLookups(error));
    }
  }

  Future<void> _handleRoleTap(AuthGateRole role) async {
    if (_activeRole != null) return;

    setState(() => _activeRole = role);
    try {
      final registrationData = await _registrationDataFuture;
      if (!mounted) return;

      if (role == AuthGateRole.user) {
        context.push(AppRouter.signupPath, extra: registrationData);
      } else {
        context.push(AppRouter.providerSignupPath, extra: registrationData);
      }
    } on _PreloadException catch (error) {
      if (!mounted) return;
      AppSnackbar.showError(context, error.messageKey.tr());
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.showError(context, LocaleKeys.auth_error_generic.tr());
    } finally {
      if (mounted) {
        setState(() => _activeRole = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const AuthGateIntroSection(),
              const SizedBox(height: 48),
              AuthGateRolesSection(
                activeRole: _activeRole,
                onRoleTap: _handleRoleTap,
              ),
              const SizedBox(height: 48),
              AuthTextLinkRow(
                prefixText: LocaleKeys.have_account.tr(),
                linkText: LocaleKeys.sign_in_link.tr(),
                onTap: () => context.push(AppRouter.loginPath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreloadException implements Exception {
  const _PreloadException(this.messageKey);

  final String messageKey;
}
