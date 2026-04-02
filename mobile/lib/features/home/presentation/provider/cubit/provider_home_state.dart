import 'package:dar_care/features/orders/data/models/order_model.dart';

enum ProviderHomeStatus { initial, loading, success, failure }

class ProviderHomeState {
  const ProviderHomeState({
    this.status = ProviderHomeStatus.initial,
    this.totalEarnings = 0,
    this.completedJobs = 0,
    this.averageRating = 0,
    this.isAvailable = false,
    this.isUpdatingAvailability = false,
    this.pendingOrders = const <OrderModel>[],
    this.errorMessageKey,
  });

  final ProviderHomeStatus status;
  final double totalEarnings;
  final int completedJobs;
  final double averageRating;
  final bool isAvailable;
  final bool isUpdatingAvailability;
  final List<OrderModel> pendingOrders;
  final String? errorMessageKey;

  ProviderHomeState copyWith({
    ProviderHomeStatus? status,
    double? totalEarnings,
    int? completedJobs,
    double? averageRating,
    bool? isAvailable,
    bool? isUpdatingAvailability,
    List<OrderModel>? pendingOrders,
    String? errorMessageKey,
    bool clearErrorMessage = false,
  }) {
    return ProviderHomeState(
      status: status ?? this.status,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      completedJobs: completedJobs ?? this.completedJobs,
      averageRating: averageRating ?? this.averageRating,
      isAvailable: isAvailable ?? this.isAvailable,
      isUpdatingAvailability:
          isUpdatingAvailability ?? this.isUpdatingAvailability,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      errorMessageKey: clearErrorMessage
          ? null
          : (errorMessageKey ?? this.errorMessageKey),
    );
  }
}

