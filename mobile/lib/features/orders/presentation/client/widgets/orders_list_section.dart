import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import 'order_history_card.dart';
import 'orders_empty_state.dart';
import 'orders_error_state.dart';
import 'orders_loading_state.dart';

class OrdersListSection extends StatelessWidget {
  const OrdersListSection({super.key, required this.selectedFilter});

  final String selectedFilter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.status == OrdersStatus.loading && state.orders.isEmpty) {
          return const OrdersLoadingState();
        }

        if (state.status == OrdersStatus.failure && state.orders.isEmpty) {
          return OrdersErrorState(
            messageKey: state.errorMessage,
            onRetry: () => context.read<OrdersCubit>().loadOrders(),
          );
        }

        final filteredOrders = state.orders
            .where(
              (order) => OrderPresentationUtils.matchesFilter(
                orderStatus: order.status,
                selectedFilter: selectedFilter,
              ),
            )
            .toList(growable: false);

        if (filteredOrders.isEmpty) {
          return const OrdersEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => context.read<OrdersCubit>().loadOrders(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: filteredOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return OrderHistoryCard(order: filteredOrders[index]);
            },
          ),
        );
      },
    );
  }
}
