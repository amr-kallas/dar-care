import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/features/home/presentation/client/widgets/client_home_error_state.dart';
import 'package:dar_care/features/home/presentation/client/widgets/client_home_header.dart';
import 'package:dar_care/features/home/presentation/client/widgets/client_home_providers_section.dart';
import 'package:dar_care/features/home/presentation/client/widgets/client_home_search_bar.dart';
import 'package:dar_care/features/home/presentation/client/widgets/client_home_services_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/home/presentation/client/cubit/home_cubit.dart';
import 'package:dar_care/features/home/presentation/client/cubit/home_state.dart';

class ClientHomeBody extends StatelessWidget {
  const ClientHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final languageCode = context.locale.languageCode;
    final currentUserId = resolveAuthUser(context.read<AuthCubit>().state)?.id;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const AppLoadingIndicator();
        }

        if (state.status == HomeStatus.failure) {
          return ClientHomeErrorState(errorKey: state.errorMessage);
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const ClientHomeHeader(),
                const SizedBox(height: 24),
                ClientHomeSearchBar(isDark: isDark),
                const SizedBox(height: 32),
                ClientHomeServicesSection(
                  categories: state.categories,
                  languageCode: languageCode,
                ),
                const SizedBox(height: 32),
                ClientHomeProvidersSection(
                  topProviders: state.topProviders,
                  currentUserId: currentUserId,
                  languageCode: languageCode,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}
