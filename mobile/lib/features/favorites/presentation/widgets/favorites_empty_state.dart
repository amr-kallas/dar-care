import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

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
          Text('No favorites yet', style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
