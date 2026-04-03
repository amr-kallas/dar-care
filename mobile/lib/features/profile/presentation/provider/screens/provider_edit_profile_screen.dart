import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/localized_db_text.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderEditProfileScreen extends StatefulWidget {
  const ProviderEditProfileScreen({super.key});

  @override
  State<ProviderEditProfileScreen> createState() => _ProviderEditProfileScreenState();
}

class _ProviderEditProfileScreenState extends State<ProviderEditProfileScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _providerId;
  String? _selectedDepartmentId;

  List<_DepartmentOption> _departments = const <_DepartmentOption>[];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
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

      final departmentsResponse = await _supabase
          .from('departments')
          .select('id, name')
          .order('name');

      final departmentOptions = (departmentsResponse as List<dynamic>)
          .map((row) => _DepartmentOption.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);

      if (!mounted) {
        return;
      }

      setState(() {
        _providerId = providerRow['id'].toString();
        _bioController.text = (providerRow['bio'] as String?) ?? '';
        _experienceController.text =
            (providerRow['experience_years'] as int?)?.toString() ?? '';
        _selectedDepartmentId = providerRow['department_id']?.toString();
        _departments = departmentOptions;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
      AppSnackbar.showError(context, 'provider_profile_load_error'.tr());
    }
  }

  Future<void> _save() async {
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

      if (!mounted) {
        return;
      }

      AppSnackbar.showSuccess(context, 'provider_profile_save_success'.tr());
      context.pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppSnackbar.showError(context, 'provider_profile_save_error'.tr());
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageCode = context.locale.languageCode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleWidget: Text(
          'edit_profile'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const AppLoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: 40,
              ),
              child: Column(
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
                      isExpanded: true,
                      items: _departments
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item.id,
                              child: Text(item.resolveName(languageCode)),
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
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
              ),
            ),
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
  const _DepartmentOption({required this.id, required this.nameText});

  final String id;
  final LocalizedDbText nameText;

  String resolveName(String languageCode) {
    return nameText.resolve(languageCode: languageCode, emptyValue: id);
  }

  factory _DepartmentOption.fromJson(Map<String, dynamic> json) {
    return _DepartmentOption(
      id: (json['id'] ?? '').toString(),
      nameText: LocalizedDbText.fromSupabase(json['name']),
    );
  }
}

