import 'package:dar_care/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth_state.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:dar_care/features/home/presentation/provider/screens/provider_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:go_router/go_router.dart';

import 'client/screens/client_main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRouter.loginPath);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user.role == UserRole.provider) {
            return const ProviderMainScreen();
          }
          return const ClientMainScreen();
        } else if (state is AuthSignInSuccess) {
          if (state.user.role == UserRole.provider) {
            return const ProviderMainScreen();
          }
          return const ClientMainScreen();
        } else if (state is AuthSignUpSuccess) {
          if (state.user.role == UserRole.provider) {
            return const ProviderMainScreen();
          }
          return const ClientMainScreen();
        } else if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something went wrong'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AuthCubit>().checkAuthStatus(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Fallback or loading state
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
