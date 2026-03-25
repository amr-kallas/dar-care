import 'package:equatable/equatable.dart';
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';

/// Base class for all Auth states
abstract class AuthState extends Equatable {
  const AuthState();
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object?> get props => [];
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
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
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
