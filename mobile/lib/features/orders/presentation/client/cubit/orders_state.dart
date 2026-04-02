import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_state.freezed.dart';

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default([]) List<OrderModel> orders,
    @Default(OrdersStatus.initial) OrdersStatus status,
    String? errorMessage,
  }) = _OrdersState;
}

enum OrdersStatus { initial, loading, success, failure }
