import 'package:dar_care/core/utils/app_refresh_notifier.dart';
import 'package:dar_care/core/utils/orders_error_utils.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'provider_order_details_state.dart';

class ProviderOrderDetailsCubit extends Cubit<ProviderOrderDetailsState> {
  ProviderOrderDetailsCubit(
    this._ordersRepository, {
    required ProviderOrderDetailsState initialState,
  }) : super(initialState);

  final OrdersRepository _ordersRepository;

  Future<void> acceptAndSendQuote(String quoteInput) async {
    final parsedQuote = double.tryParse(quoteInput.trim());
    if (parsedQuote == null || parsedQuote <= 0) {
      emit(
        state.copyWith(
          status: ProviderOrderDetailsStatus.failure,
          errorMessageKey: 'provider_quote_validation_error',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ProviderOrderDetailsStatus.submitting,
        clearError: true,
      ),
    );

    try {
      await _ordersRepository.acceptOrderWithQuote(
        orderId: state.order.id,
        quotePrice: parsedQuote,
      );
      emit(
        state.copyWith(
          status: ProviderOrderDetailsStatus.success,
          clearError: true,
        ),
      );
      appRefreshNotifier.markAllForOrderUpdate();
    } catch (e) {
      emit(
        state.copyWith(
          status: ProviderOrderDetailsStatus.failure,
          errorMessageKey: resolveOrdersErrorMessageKey(e),
        ),
      );
    }
  }

  Future<void> rejectOrder() async {
    emit(
      state.copyWith(
        status: ProviderOrderDetailsStatus.submitting,
        clearError: true,
      ),
    );

    try {
      await _ordersRepository.rejectOrder(orderId: state.order.id);
      emit(
        state.copyWith(
          status: ProviderOrderDetailsStatus.success,
          clearError: true,
        ),
      );
      appRefreshNotifier.markAllForOrderUpdate();
    } catch (e) {
      emit(
        state.copyWith(
          status: ProviderOrderDetailsStatus.failure,
          errorMessageKey: resolveOrdersErrorMessageKey(e),
        ),
      );
    }
  }
}
