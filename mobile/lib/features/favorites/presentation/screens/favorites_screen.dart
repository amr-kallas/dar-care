import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/favorites/presentation/widgets/favorites_screen_content.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleWidget: Text(LocaleKeys.favorites_tab.tr())),
      body: BlocListener<FavoritesCubit, FavoritesState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          final messageKey = state.errorMessage;
          if (messageKey == null || messageKey.isEmpty) {
            return;
          }

          AppSnackbar.showError(context, messageKey.tr());
        },
        child: const FavoritesScreenContent(),
      ),
    );
  }
}
