import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/home_presentation_utils.dart';
import 'package:dar_care/gen/assets.gen.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';

class ClientHomeHeader extends StatelessWidget {
  const ClientHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.transparent : Colors.grey.shade200,
            ),
          ),
          child: const Stack(
            children: [
              Icon(SolarLinearIcons.bell),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: AppColors.errorRed,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  LocaleKeys.good_morning.tr(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 4),
                const Icon(
                  SolarBoldIcons.sun,
                  size: 14,
                  color: AppColors.warningOrange,
                ),
              ],
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final name = HomePresentationUtils.welcomeName(authState);
                return Text(
                  LocaleKeys.welcome_back.tr(namedArgs: {'name': name}),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 24,
          backgroundImage: Assets.images.png.defaultAvatar.provider(),
        ),
      ],
    );
  }
}

