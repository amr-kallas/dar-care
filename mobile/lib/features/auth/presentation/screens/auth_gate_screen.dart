import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/features/auth/data/repositories/city_repository.dart';
import 'package:dar_care/features/auth/domain/usecases/get_departments_use_case.dart';
import 'package:dar_care/features/auth/presentation/models/auth_registration_data.dart';
import 'package:dar_care/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../widgets/auth_text_link_row.dart';
import '../widgets/role_card.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  final CityRepository _cityRepository = CityRepository();
  late final Future<AuthRegistrationData> _registrationDataFuture;

  _AuthRole? _activeRole;

  @override
  void initState() {
    super.initState();
    _registrationDataFuture = _preloadRegistrationData();
  }

  Future<AuthRegistrationData> _preloadRegistrationData() async {
    try {
      final citiesFuture = _cityRepository.getCities();
      final departmentsFuture = getIt<GetDepartmentsUseCase>()();

      final cities = await citiesFuture;
      final departments = await departmentsFuture;

      return AuthRegistrationData(cities: cities, departments: departments);
    } catch (error) {
      throw _PreloadException(AuthErrorMapper.registrationLookups(error));
    }
  }

  Future<void> _handleRoleTap(_AuthRole role) async {
    if (_activeRole != null) return;

    setState(() => _activeRole = role);
    try {
      final registrationData = await _registrationDataFuture;
      if (!mounted) return;

      if (role == _AuthRole.user) {
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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Header
              Text(
                LocaleKeys.auth_gate_title.tr(),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.auth_gate_subtitle.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // User Card
              RoleCard(
                title: LocaleKeys.auth_user_title.tr(),
                description: LocaleKeys.auth_user_description.tr(),
                icon: SolarLinearIcons.user,
                buttonText: LocaleKeys.auth_user_button.tr(),
                isLoading: _activeRole == _AuthRole.user,
                onPressed: () => _handleRoleTap(_AuthRole.user),
              ),

              const SizedBox(height: 24),

              // Professional Card
              RoleCard(
                title: LocaleKeys.auth_professional_title.tr(),
                description: LocaleKeys.auth_professional_description.tr(),
                icon: SolarLinearIcons.widget,
                buttonText: LocaleKeys.auth_professional_button.tr(),
                isLoading: _activeRole == _AuthRole.provider,
                onPressed: () => _handleRoleTap(_AuthRole.provider),
              ),

              const SizedBox(height: 48),

              // Login Link
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

enum _AuthRole { user, provider }

class _PreloadException implements Exception {
  const _PreloadException(this.messageKey);

  final String messageKey;
}
