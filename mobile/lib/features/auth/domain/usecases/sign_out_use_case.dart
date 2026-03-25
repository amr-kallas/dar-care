import 'package:injectable/injectable.dart';
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user sign out
@injectable
class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() async {
    return await repository.signOut();
  }
}
