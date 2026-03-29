import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Authentication Cubit for managing auth state
@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
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
      await signOutUseCase();
      emit(const AuthSignOutSuccess());
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
}
