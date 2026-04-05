import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:dar_care/features/home/presentation/provider/screens/provider_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dar_care/generated/locale_keys.g.dart';

import 'client/screens/client_main_screen.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/app_primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRouter.loginPath);
        } else if (state is AuthError) {
          AppSnackbar.showError(context, state.messageKey.tr());
        }
      },
      builder: (context, state) {
        final user = resolveAuthUser(state);

        if (user != null) {
          if (user.role == UserRole.provider) {
            return const ProviderMainScreen();
          }
          return const ClientMainScreen();
        }

        if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocaleKeys.auth_error_generic.tr()),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AppPrimaryButton(
                      label: LocaleKeys.orders_retry_button.tr(),
                      onPressed: () =>
                          context.read<AuthCubit>().checkAuthStatus(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: AppLoadingIndicator());
      },
    );
  }
}
