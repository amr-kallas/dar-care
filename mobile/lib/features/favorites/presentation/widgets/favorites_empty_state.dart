import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dar_care/generated/locale_keys.g.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(SolarLinearIcons.heart, size: 42, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.favorites_empty_title.tr(),
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
