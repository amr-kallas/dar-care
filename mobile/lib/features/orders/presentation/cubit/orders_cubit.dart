import 'package:dar_care/features/home/client/data/models/provider_model.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:dar_care/features/orders/presentation/cubit/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit(this._repository) : super(const OrdersState());

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading));

    try {
      final orders = await _repository.getClientOrders();
      emit(state.copyWith(
        status: OrdersStatus.success,
        orders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> createOrder({
    required ProviderModel provider,
    required DateTime serviceDate,
    required String address,
    required String notes,
  }) async {
    emit(state.copyWith(status: OrdersStatus.loading));

    try {
      await _repository.createOrder(
          provider: provider,
          serviceDate: serviceDate,
          address: address,
          notes: notes,
      );

      // Reload orders to show new one
      await loadOrders();
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

