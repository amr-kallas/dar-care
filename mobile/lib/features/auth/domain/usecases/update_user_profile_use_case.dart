import 'dart:typed_data';

import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserProfileUseCase {
  final AuthRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  Future<void> call({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) {
    return _repository.updateUserProfile(
      userId: userId,
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  Future<String> uploadAndUpdateAvatar({
    required String userId,
    required Uint8List fileBytes,
  }) {
    return _repository.uploadAndUpdateAvatar(
      userId: userId,
      fileBytes: fileBytes,
    );
  }
}
