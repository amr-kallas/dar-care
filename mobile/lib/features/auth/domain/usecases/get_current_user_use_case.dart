import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<AuthUser?> call() async {
    return await _repository.getCurrentUser();
  }
}

