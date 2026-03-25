import 'package:injectable/injectable.dart';
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user sign in
@injectable
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<AuthUser> call({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(email: email, password: password);
  }
}
