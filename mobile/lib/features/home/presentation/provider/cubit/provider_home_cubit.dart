import 'package:dar_care/core/utils/home_error_utils.dart';
import 'package:dar_care/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'provider_home_state.dart';

class ProviderHomeCubit extends Cubit<ProviderHomeState> {
  ProviderHomeCubit(this._homeRepository) : super(const ProviderHomeState());

  final HomeRepository _homeRepository;

  Future<void> loadDashboard() async {
    emit(
      state.copyWith(
        status: ProviderHomeStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final summary = await _homeRepository.getProviderDashboardSummary();
      final pendingOrders = await _homeRepository.getProviderLatestPendingOrders();

      emit(
        state.copyWith(
          status: ProviderHomeStatus.success,
          totalEarnings: summary.totalEarnings,
          completedJobs: summary.completedJobs,
          averageRating: summary.averageRating,
          isAvailable: summary.isAvailable,
          pendingOrders: pendingOrders,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProviderHomeStatus.failure,
          errorMessageKey: resolveHomeErrorMessageKey(e),
        ),
      );
    }
  }

  Future<void> toggleAvailability(bool isAvailable) async {
    final previousState = state;

    emit(
      state.copyWith(
        isAvailable: isAvailable,
        isUpdatingAvailability: true,
      ),
    );

    try {
      await _homeRepository.updateProviderAvailability(isAvailable: isAvailable);
      emit(
        state.copyWith(
          isUpdatingAvailability: false,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        previousState.copyWith(
          isUpdatingAvailability: false,
          errorMessageKey: resolveHomeErrorMessageKey(e),
        ),
      );
    }
  }
}

