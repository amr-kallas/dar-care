import 'package:dar_care/features/orders/data/models/order_model.dart';

enum ProviderOrdersStatus { initial, loading, success, failure }

class ProviderOrdersState {
  const ProviderOrdersState({
    this.status = ProviderOrdersStatus.initial,
    this.orders = const <OrderModel>[],
    this.errorMessageKey,
  });

  final ProviderOrdersStatus status;
  final List<OrderModel> orders;
  final String? errorMessageKey;

  ProviderOrdersState copyWith({
    ProviderOrdersStatus? status,
    List<OrderModel>? orders,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return ProviderOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
    );
  }
}

