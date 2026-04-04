import 'package:dar_care/features/notifications/data/models/notification_model.dart';
import 'package:dar_care/features/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsHistoryUseCase {
  GetNotificationsHistoryUseCase(this._repository);

  final NotificationRepository _repository;

  Future<List<NotificationModel>> call() {
    return _repository.getNotificationsHistory();
  }
}

