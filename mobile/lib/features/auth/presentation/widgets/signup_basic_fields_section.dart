import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/features/auth/data/models/app_city.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class SignupBasicFieldsSection extends StatelessWidget {
  const SignupBasicFieldsSection({super.key, required this.cities});

  final List<AppCity> cities;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return Column(
      children: [
        ReactiveTextField<String>(
          formControlName: 'fullName',
          decoration: InputDecoration(
            labelText: LocaleKeys.label_full_name.tr(),
            prefixIcon: const Icon(SolarLinearIcons.user),
          ),
          validationMessages: ValidationMessages.fullName,
        ),
        const SizedBox(height: 16),
        ReactiveTextField<String>(
          formControlName: 'email',
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_email.tr(),
            prefixIcon: const Icon(SolarLinearIcons.global),
          ),
          validationMessages: ValidationMessages.email,
        ),
        const SizedBox(height: 16),
        ReactiveTextField<String>(
          formControlName: 'phoneNumber',
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_phone_number.tr(),
            prefixIcon: const Icon(SolarLinearIcons.chatRoundLine),
            hintText: LocaleKeys.hint_phone_number.tr(),
          ),
          validationMessages: ValidationMessages.phoneNumber,
        ),
        const SizedBox(height: 16),
        ReactiveDropdownField<AppCity?>(
          formControlName: 'city',
          decoration: InputDecoration(
            labelText: LocaleKeys.label_city.tr(),
            prefixIcon: const Icon(SolarLinearIcons.mapPoint),
            hintText: LocaleKeys.hint_city.tr(),
          ),
          items: cities
              .map(
                (city) => DropdownMenuItem<AppCity?>(
                  value: city,
                  child: Text(city.nameForLanguage(languageCode)),
                ),
              )
              .toList(),
          validationMessages: ValidationMessages.city,
        ),
        const SizedBox(height: 16),
        ReactiveTextField<String>(
          formControlName: 'password',
          obscureText: true,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_password.tr(),
            prefixIcon: const Icon(SolarLinearIcons.shieldKeyhole),
          ),
          validationMessages: ValidationMessages.password,
        ),
      ],
    );
  }
}
