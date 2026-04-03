import 'dart:async';
import 'dart:typed_data';

import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/update_user_profile_use_case.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Authentication Cubit for managing auth state
@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  AuthCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateUserProfileUseCase,
  }) : super(const AuthInitial());

  /// Sign up a standard client user
  Future<void> signUpClient({
    required String email,
    required String password,
    required String fullName,
    required String cityId,
    String? phone,
  }) async {
    if (state is AuthLoading &&
        (state as AuthLoading).operation == AuthOperation.signUp) {
      return;
    }

    try {
      emit(const AuthLoading(operation: AuthOperation.signUp));
      final user = await signUpUseCase.signUpClient(
        email: email,
        password: password,
        fullName: fullName,
        cityId: cityId,
        phone: phone,
      );
      emit(AuthSignUpSuccess(user));
    } catch (error) {
      emit(AuthError(AuthErrorMapper.signUpClient(error)));
    }
  }

  /// Sign up a professional provider
  Future<void> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cityId,
    required String departmentId,
    required int experienceYears,
    String? bio,
  }) async {
    if (state is AuthLoading &&
        (state as AuthLoading).operation == AuthOperation.signUp) {
      return;
    }

    try {
      emit(const AuthLoading(operation: AuthOperation.signUp));
      final user = await signUpUseCase.signUpProvider(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        cityId: cityId,
        departmentId: departmentId,
        experienceYears: experienceYears,
        bio: bio,
      );
      emit(AuthSignUpSuccess(user));
    } catch (error) {
      emit(AuthError(AuthErrorMapper.signUpProvider(error)));
    }
  }

  /// Sign in a user
  Future<void> signIn({required String email, required String password}) async {
    if (state is AuthLoading &&
        (state as AuthLoading).operation == AuthOperation.signIn) {
      return;
    }

    try {
      emit(const AuthLoading(operation: AuthOperation.signIn));
      final user = await signInUseCase(email: email, password: password);
      emit(AuthSignInSuccess(user));
    } catch (error) {
      emit(AuthError(AuthErrorMapper.signIn(error)));
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      emit(const AuthLoading(operation: AuthOperation.signOut));
      await signOutUseCase().timeout(const Duration(seconds: 12));
      emit(const AuthSignOutSuccess());
      emit(const AuthUnauthenticated());
    } on TimeoutException {
      // Keep UX responsive when network revoke is slow; local session is cleared by datasource fallback.
      emit(const AuthUnauthenticated());
    } catch (error) {
      emit(AuthError(AuthErrorMapper.signOut(error)));
    }
  }

  /// Check if user is authenticated on app start
  Future<void> checkAuthStatus() async {
    try {
      final session = SupabaseService.auth.currentSession;
      if (session != null) {
        emit(const AuthLoading(operation: AuthOperation.checkSession));
        final user = await getCurrentUserUseCase();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          await signOut();
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (error) {
      emit(AuthError(AuthErrorMapper.session(error)));
    }
  }

  /// Upload and update user avatar
  Future<void> uploadAndUpdateAvatar({
    required String userId,
    required Uint8List fileBytes,
  }) async {
    if (state is AuthLoading &&
        (state as AuthLoading).operation == AuthOperation.uploadAvatar) {
      return;
    }

    final previousState = state;

    try {
      emit(const AuthLoading(operation: AuthOperation.uploadAvatar));
      final avatarUrl = await updateUserProfileUseCase.uploadAndUpdateAvatar(
        userId: userId,
        fileBytes: fileBytes,
      );

      final previousUser = resolveAuthUser(previousState);
      if (previousUser != null) {
        emit(AuthAuthenticated(previousUser.copyWith(avatarUrl: avatarUrl)));
      }

      // Best effort refresh so UI does not fail when read-back is temporarily blocked.
      final refreshedUser = await getCurrentUserUseCase();
      if (refreshedUser != null) {
        emit(AuthAuthenticated(refreshedUser));
      } else if (previousUser == null) {
        emit(const AuthError(LocaleKeys.auth_error_generic));
      }
    } catch (error) {
      emit(AuthError(AuthErrorMapper.updateProfile(error)));
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String phone,
    String? avatarUrl,
  }) async {
    if (state is AuthLoading &&
        (state as AuthLoading).operation == AuthOperation.updateProfile) {
      return;
    }

    try {
      emit(const AuthLoading(operation: AuthOperation.updateProfile));
      await updateUserProfileUseCase(
        userId: userId,
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );

      final refreshedUser = await getCurrentUserUseCase();
      if (refreshedUser != null) {
        emit(AuthAuthenticated(refreshedUser));
      } else {
        emit(const AuthError(LocaleKeys.auth_error_generic));
      }
    } catch (error) {
      emit(AuthError(AuthErrorMapper.updateProfile(error)));
    }
  }
}
