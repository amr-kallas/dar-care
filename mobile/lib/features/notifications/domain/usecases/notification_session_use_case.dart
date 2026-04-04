import 'dart:async';

import 'package:dar_care/features/auth/domain/usecases/sync_fcm_token_use_case.dart';
import 'package:dar_care/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationSessionUseCase {
  NotificationSessionUseCase(this._repository, this._syncFcmTokenUseCase);

  final NotificationRepository _repository;
  final SyncFcmTokenUseCase _syncFcmTokenUseCase;
  StreamSubscription<String>? _fcmTokenRefreshSubscription;

  Future<void> initializeForUser(String userId) async {
    await _repository.initializeHandlers();
    await _repository.requestPermission();

    final token = await _repository.getToken();
    if (token != null && token.isNotEmpty) {
      await _syncFcmTokenUseCase(userId: userId, fcmToken: token);
    }

    await _fcmTokenRefreshSubscription?.cancel();
    _fcmTokenRefreshSubscription = _repository.onTokenRefresh.listen((token) {
      _syncFcmTokenUseCase(userId: userId, fcmToken: token);
    });
  }

  Future<void> clearForUser(String userId) async {
    await _fcmTokenRefreshSubscription?.cancel();
    _fcmTokenRefreshSubscription = null;
    await _syncFcmTokenUseCase(userId: userId, fcmToken: null);
  }
}

