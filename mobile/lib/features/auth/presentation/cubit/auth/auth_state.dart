import 'package:equatable/equatable.dart';
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';

/// Base class for all Auth states
abstract class AuthState extends Equatable {
  const AuthState();
}

enum AuthOperation {
  signIn,
  signUp,
  signOut,
  checkSession,
  updateProfile,
  uploadAvatar,
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading({this.operation});

  final AuthOperation? operation;

  @override
  List<Object?> get props => [operation];
}

/// Authenticated state
class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object?> get props => [];
}

/// Authentication error state
class AuthError extends AuthState {
  final String messageKey;

  const AuthError(this.messageKey);

  @override
  List<Object?> get props => [messageKey];
}

/// Sign up success state
class AuthSignUpSuccess extends AuthState {
  final AuthUser user;

  const AuthSignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Sign in success state
class AuthSignInSuccess extends AuthState {
  final AuthUser user;

  const AuthSignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Sign out success state
class AuthSignOutSuccess extends AuthState {
  const AuthSignOutSuccess();

  @override
  List<Object?> get props => [];
}
