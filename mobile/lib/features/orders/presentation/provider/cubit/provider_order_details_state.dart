import 'package:dar_care/features/orders/data/models/order_model.dart';

enum ProviderOrderDetailsStatus { idle, submitting, success, failure }

class ProviderOrderDetailsState {
  const ProviderOrderDetailsState({
    required this.order,
    this.status = ProviderOrderDetailsStatus.idle,
    this.errorMessageKey,
  });

  final OrderModel order;
  final ProviderOrderDetailsStatus status;
  final String? errorMessageKey;

  ProviderOrderDetailsState copyWith({
    OrderModel? order,
    ProviderOrderDetailsStatus? status,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return ProviderOrderDetailsState(
      order: order ?? this.order,
      status: status ?? this.status,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
    );
  }
}

