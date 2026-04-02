import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/theme/theme_controller.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/core/utils/profile_preferences_utils.dart';
import 'package:dar_care/core/widgets/app_confirmation_dialog.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/profile/presentation/widgets/logout_button.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_header.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_language_sheet.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_menu_section.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_theme_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _providerId;
  String? _selectedDepartmentId;
  double _walletBalance = 0;

  List<_DepartmentOption> _departments = const <_DepartmentOption>[];
  List<_ProviderReview> _reviews = const <_ProviderReview>[];

  @override
  void initState() {
    super.initState();
    _loadProviderProfile();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _loadProviderProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw StateError('No authenticated user.');
      }

      final providerRow = await _supabase
          .from('providers')
          .select('id, bio, experience_years, department_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (providerRow == null || providerRow['id'] == null) {
        throw StateError('Provider profile not found.');
      }

      final providerId = providerRow['id'].toString();

      final departmentsResponse = await _supabase
          .from('departments')
          .select('id, name')
          .order('name');

      final departmentOptions = (departmentsResponse as List<dynamic>)
          .map((row) => _DepartmentOption.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);

      final ordersResponse = await _supabase
          .from('orders')
          .select('id')
          .eq('provider_id', providerId);

      final orderIds = (ordersResponse as List<dynamic>)
          .map((row) => row['id']?.toString())
          .whereType<String>()
          .toList(growable: false);

      double balance = 0;
      if (orderIds.isNotEmpty) {
        final paymentsResponse = await _supabase
            .from('payments')
            .select('amount')
            .inFilter('order_id', orderIds);

        for (final payment in (paymentsResponse as List<dynamic>)) {
          final amount = payment['amount'];
          if (amount is num) {
            balance += amount.toDouble();
          } else if (amount != null) {
            balance += double.tryParse(amount.toString()) ?? 0;
          }
        }
      }

      final ratingsResponse = await _supabase
          .from('ratings')
          .select('rating_value, comment, created_at, clients(users(full_name))')
          .eq('provider_id', providerId)
          .order('created_at', ascending: false);

      final reviews = (ratingsResponse as List<dynamic>)
          .map((row) => _ProviderReview.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);

      if (!mounted) return;

      setState(() {
        _providerId = providerId;
        _bioController.text = (providerRow['bio'] as String?) ?? '';
        _experienceController.text =
            (providerRow['experience_years'] as int?)?.toString() ?? '';
        _selectedDepartmentId = providerRow['department_id']?.toString();
        _departments = departmentOptions;
        _walletBalance = balance;
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      AppSnackbar.showError(context, 'provider_profile_load_error'.tr());
    }
  }

  Future<void> _saveProfile() async {
    if (_providerId == null) {
      AppSnackbar.showError(context, 'provider_profile_load_error'.tr());
      return;
    }

    final experience = int.tryParse(_experienceController.text.trim());
    if (experience == null || experience < 0) {
      AppSnackbar.showError(context, 'validation_invalid_experience'.tr());
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _supabase
          .from('providers')
          .update({
            'bio': _bioController.text.trim(),
            'experience_years': experience,
            'department_id': _selectedDepartmentId,
          })
          .eq('id', _providerId!);

      if (!mounted) return;
      AppSnackbar.showSuccess(context, 'provider_profile_save_success'.tr());
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'provider_profile_save_error'.tr());
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _showLanguagePicker() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLanguageCode = context.locale.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return ProfileLanguageSheet(
          isDark: isDark,
          currentLanguageCode: currentLanguageCode,
          onLanguageSelected: (locale) async {
            if (currentLanguageCode != locale.languageCode) {
              await context.setLocale(locale);
            }
            if (mounted) Navigator.of(bottomSheetContext).pop();
          },
        );
      },
    );
  }

  Future<void> _showThemePicker() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentThemeMode = ThemeController.instance.themeMode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return ProfileThemeSheet(
          isDark: isDark,
          currentThemeMode: currentThemeMode,
          onThemeSelected: (mode) async {
            await ThemeController.instance.setThemeMode(mode);
            if (mounted) Navigator.of(bottomSheetContext).pop();
          },
        );
      },
    );
  }

  Future<void> _onLogoutPressed(bool isSigningOut) async {
    if (isSigningOut) return;

    final shouldLogout = await showAppConfirmationDialog(
      context: context,
      title: 'logout_confirm_title'.tr(),
      message: 'logout_confirm_message'.tr(),
      confirmText: 'confirm'.tr(),
      cancelText: 'cancel'.tr(),
      isDestructive: true,
    );

    if (!mounted || !shouldLogout) return;
    await context.read<AuthCubit>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthCubit>().state;
    final user = resolveAuthUser(authState);
    final isSigningOut =
        authState is AuthLoading && authState.operation == AuthOperation.signOut;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleWidget: Text(
          'provider_profile_title'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const AppLoadingIndicator()
          : RefreshIndicator(
              onRefresh: _loadProviderProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 8,
                  bottom: 120,
                ),
                child: Column(
                  children: [
                    ProfileHeader(user: user),
                    const SizedBox(height: 24),
                    _buildEditableSection(isDark),
                    const SizedBox(height: 20),
                    _buildWalletSection(isDark),
                    const SizedBox(height: 20),
                    _buildReviewsSection(isDark),
                    const SizedBox(height: 20),
                    ProfileMenuSection(
                      title: 'settings_tab'.tr(),
                      children: [
                        ProfileMenuItem(
                          title: 'language'.tr(),
                          icon: SolarLinearIcons.global,
                          isPrimaryIcon: true,
                          trailingText:
                              ProfilePreferencesUtils.currentLanguageLabel(context),
                          onTap: _showLanguagePicker,
                        ),
                        ProfileMenuItem(
                          title: 'theme'.tr(),
                          icon: SolarLinearIcons.moon,
                          isPrimaryIcon: true,
                          trailingText: ProfilePreferencesUtils.currentThemeLabel(),
                          onTap: _showThemePicker,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    LogoutButton(
                      isLoading: isSigningOut,
                      onTap: () => _onLogoutPressed(isSigningOut),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEditableSection(bool isDark) {
    return ProfileMenuSection(
      title: 'provider_profile_professional_info'.tr(),
      children: [
        _FormContainer(
          isDark: isDark,
          child: TextField(
            controller: _bioController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'provider_profile_bio'.tr(),
              border: InputBorder.none,
            ),
          ),
        ),
        _FormContainer(
          isDark: isDark,
          child: TextField(
            controller: _experienceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'provider_profile_experience_years'.tr(),
              border: InputBorder.none,
            ),
          ),
        ),
        _FormContainer(
          isDark: isDark,
          child: DropdownButtonFormField<String>(
            initialValue: _selectedDepartmentId,
            items: _departments
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.id,
                    child: Text(item.name),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              setState(() {
                _selectedDepartmentId = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'provider_profile_department'.tr(),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('provider_profile_save_changes'.tr()),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletSection(bool isDark) {
    return ProfileMenuSection(
      title: 'provider_profile_wallet_title'.tr(),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
            ),
          ),
          child: Row(
            children: [
              const Icon(SolarLinearIcons.wallet, color: AppColors.brightGreen),
              const SizedBox(width: 12),
              Text(
                'provider_profile_total_balance'.tr(
                  namedArgs: {'amount': _walletBalance.toStringAsFixed(0)},
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(bool isDark) {
    return ProfileMenuSection(
      title: 'provider_profile_reviews_title'.tr(),
      children: [
        if (_reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Text(
              'provider_profile_no_reviews'.tr(),
              style: TextStyle(
                color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
              ),
            ),
          )
        else
          ..._reviews.map(
            (review) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          review.clientName,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ...List<Widget>.generate(
                        5,
                        (index) => Icon(
                          index < review.rating.round()
                              ? SolarBoldIcons.star
                              : SolarLinearIcons.star,
                          size: 14,
                          color: AppColors.ratingYellow,
                        ),
                      ),
                    ],
                  ),
                  if (review.comment.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      review.comment,
                      style: TextStyle(
                        color: isDark ? AppColors.lightGrey : AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _FormContainer extends StatelessWidget {
  const _FormContainer({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
        ),
      ),
      child: child,
    );
  }
}

class _DepartmentOption {
  const _DepartmentOption({required this.id, required this.name});

  final String id;
  final String name;

  factory _DepartmentOption.fromJson(Map<String, dynamic> json) {
    return _DepartmentOption(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
}

class _ProviderReview {
  const _ProviderReview({
    required this.clientName,
    required this.rating,
    required this.comment,
  });

  final String clientName;
  final double rating;
  final String comment;

  factory _ProviderReview.fromJson(Map<String, dynamic> json) {
    final client = _asMap(json['clients']);
    final user = _asMap(client['users']);
    final ratingRaw = json['rating_value'];

    return _ProviderReview(
      clientName: (user['full_name'] ?? user['name'] ?? 'User').toString(),
      rating: ratingRaw is num
          ? ratingRaw.toDouble()
          : (double.tryParse(ratingRaw?.toString() ?? '0') ?? 0),
      comment: (json['comment'] ?? '').toString().trim(),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    if (value is List && value.isNotEmpty && value.first is Map) {
      return Map<String, dynamic>.from(value.first as Map);
    }
    return <String, dynamic>{};
  }
}

