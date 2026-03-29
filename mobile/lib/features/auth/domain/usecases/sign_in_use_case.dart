import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case for user sign in
@injectable
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<AuthUser> call({required String email, required String password}) =>
      _repository.signIn(email: email, password: password);
}
