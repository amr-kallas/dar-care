import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case for user sign out
@injectable
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}
