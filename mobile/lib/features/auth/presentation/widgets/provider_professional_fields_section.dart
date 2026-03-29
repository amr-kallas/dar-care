import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/features/auth/domain/entities/department.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'auth_section_header.dart';

class ProviderProfessionalFieldsSection extends StatelessWidget {
  const ProviderProfessionalFieldsSection({
    super.key,
    required this.departments,
  });

  final List<Department> departments;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthSectionHeader(
          title: LocaleKeys.auth_provider_section_professional.tr(),
        ),
        const SizedBox(height: 16),
        ReactiveDropdownField<Department?>(
          formControlName: 'department',
          decoration: InputDecoration(
            labelText: LocaleKeys.label_department.tr(),
            prefixIcon: const Icon(SolarLinearIcons.widget),
            hintText: LocaleKeys.hint_department.tr(),
          ),
          items: departments
              .map(
                (d) => DropdownMenuItem<Department?>(
                  value: d,
                  child: Text(d.nameForLanguage(languageCode)),
                ),
              )
              .toList(),
          validationMessages: ValidationMessages.department,
        ),
        const SizedBox(height: 16),
        ReactiveTextField<String>(
          formControlName: 'experienceYears',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_experience_years.tr(),
            prefixIcon: const Icon(SolarLinearIcons.clipboardList),
            hintText: LocaleKeys.hint_experience_years.tr(),
          ),
          validationMessages: ValidationMessages.experienceYears,
        ),
        const SizedBox(height: 16),
        ReactiveTextField<String>(
          formControlName: 'bio',
          maxLines: 3,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_bio.tr(),
            hintText: LocaleKeys.hint_bio.tr(),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(SolarLinearIcons.pen),
            ),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
