import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class EditProfileFieldsSection extends StatelessWidget {
  const EditProfileFieldsSection({
    super.key,
    required this.fullNameController,
    required this.phoneController,
  });

  final TextEditingController fullNameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: fullNameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_full_name.tr(),
            prefixIcon: const Icon(SolarLinearIcons.user),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return LocaleKeys.validation_required_name.tr();
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_phone_number.tr(),
            prefixIcon: const Icon(SolarLinearIcons.phone),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return LocaleKeys.validation_required_phone.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
