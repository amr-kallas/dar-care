import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case for persisting the active push token for a user.
@injectable
class SyncFcmTokenUseCase {
  SyncFcmTokenUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String userId, String? fcmToken}) {
    return _repository.syncFcmToken(userId: userId, fcmToken: fcmToken);
  }
}

