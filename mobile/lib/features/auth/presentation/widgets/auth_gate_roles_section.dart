import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'role_card.dart';

enum AuthGateRole { user, provider }

class AuthGateRolesSection extends StatelessWidget {
  const AuthGateRolesSection({
    super.key,
    required this.activeRole,
    required this.onRoleTap,
  });

  final AuthGateRole? activeRole;
  final ValueChanged<AuthGateRole> onRoleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleCard(
          title: LocaleKeys.auth_user_title.tr(),
          description: LocaleKeys.auth_user_description.tr(),
          icon: SolarLinearIcons.user,
          buttonText: LocaleKeys.auth_user_button.tr(),
          isLoading: activeRole == AuthGateRole.user,
          onPressed: () => onRoleTap(AuthGateRole.user),
        ),
        const SizedBox(height: 24),
        RoleCard(
          title: LocaleKeys.auth_professional_title.tr(),
          description: LocaleKeys.auth_professional_description.tr(),
          icon: SolarLinearIcons.widget,
          buttonText: LocaleKeys.auth_professional_button.tr(),
          isLoading: activeRole == AuthGateRole.provider,
          onPressed: () => onRoleTap(AuthGateRole.provider),
        ),
      ],
    );
  }
}

