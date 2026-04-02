import 'package:dar_care/core/utils/orders_error_utils.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'provider_orders_state.dart';

class ProviderOrdersCubit extends Cubit<ProviderOrdersState> {
  ProviderOrdersCubit(this._ordersRepository)
      : super(const ProviderOrdersState());

  final OrdersRepository _ordersRepository;

  Future<void> loadOrders() async {
    emit(
      state.copyWith(
        status: ProviderOrdersStatus.loading,
        clearError: true,
      ),
    );

    try {
      final orders = await _ordersRepository.getProviderOrders();
      emit(
        state.copyWith(
          status: ProviderOrdersStatus.success,
          orders: orders,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProviderOrdersStatus.failure,
          errorMessageKey: resolveOrdersErrorMessageKey(e),
        ),
      );
    }
  }
}

