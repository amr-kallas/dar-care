import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:dar_care/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth_state.dart';

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
    String? phone,
  }) async {
    try {
      emit(const AuthLoading());
      final user = await signUpUseCase.signUpClient(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      emit(AuthSignUpSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Sign up a professional provider
  Future<void> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required int departmentId,
    required int experienceYears,
    String? bio,
  }) async {
    try {
      emit(const AuthLoading());
      final user = await signUpUseCase.signUpProvider(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        departmentId: departmentId,
        experienceYears: experienceYears,
        bio: bio,
      );
      emit(AuthSignUpSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Sign in a user
  Future<void> signIn({required String email, required String password}) async {
    try {
      emit(const AuthLoading());
      final user = await signInUseCase(email: email, password: password);
      emit(AuthSignInSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      emit(const AuthLoading());
      await signOutUseCase();
      emit(const AuthSignOutSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Check if user is authenticated on app start
  Future<void> checkAuthStatus() async {
    try {
      final session = SupabaseService.auth.currentSession;
      if (session != null) {
        emit(const AuthLoading());
        final user = await getCurrentUserUseCase();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          // Session exists but user not found in DB? Weird edge case.
          // Maybe force sign out or emit Unauthenticated.
          await signOut(); // Clear invalid session
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
