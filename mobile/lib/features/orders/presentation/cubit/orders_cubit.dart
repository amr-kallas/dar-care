import 'package:dar_care/core/utils/orders_error_utils.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:dar_care/features/orders/presentation/cubit/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repository) : super(const OrdersState());

  final OrdersRepository _repository;

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading, errorMessage: null));

    try {
      final orders = await _repository.getClientOrders();
      emit(
        state.copyWith(
          status: OrdersStatus.success,
          orders: orders,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: resolveOrdersErrorMessageKey(e),
        ),
      );
    }
  }

  Future<void> createOrder({
    required ProviderModel provider,
    required DateTime serviceDate,
    required String address,
    required String notes,
    String? serviceId,
    String? addressId,
  }) async {
    emit(state.copyWith(status: OrdersStatus.loading, errorMessage: null));

    try {
      await _repository.createOrder(
        provider: provider,
        serviceDate: serviceDate,
        address: address,
        notes: notes,
        serviceId: serviceId,
        addressId: addressId,
      );

      await loadOrders();
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: resolveOrdersErrorMessageKey(e),
        ),
      );
    }
  }
}
