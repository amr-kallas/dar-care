import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';

AuthUser? resolveAuthUser(AuthState state) {
  if (state is AuthAuthenticated) return state.user;
  if (state is AuthSignInSuccess) return state.user;
  if (state is AuthSignUpSuccess) return state.user;
  return null;
}
