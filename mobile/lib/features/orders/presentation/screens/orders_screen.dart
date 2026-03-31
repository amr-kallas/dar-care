import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:dar_care/features/orders/presentation/cubit/orders_state.dart';
import 'package:dar_care/features/orders/presentation/widgets/order_history_card.dart';
import 'package:dar_care/features/orders/presentation/widgets/orders_empty_state.dart';
import 'package:dar_care/features/orders/presentation/widgets/orders_error_state.dart';
import 'package:dar_care/features/orders/presentation/widgets/orders_loading_state.dart';
import 'package:dar_care/features/orders/presentation/widgets/orders_status_filter_tabs.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>()..loadOrders(),
      child: const _OrdersScreenContent(),
    );
  }
}

class _OrdersScreenContent extends StatefulWidget {
  const _OrdersScreenContent();

  @override
  State<_OrdersScreenContent> createState() => _OrdersScreenContentState();
}

class _OrdersScreenContentState extends State<_OrdersScreenContent> {
  String _selectedFilter = OrderFilterValues.all;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.deepDarkGreen
          : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.orders_history_title.tr(),
        backgroundColor: isDark
            ? AppColors.deepDarkGreen
            : AppColors.backgroundLight,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            OrdersStatusFilterTabs(
              selectedFilter: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state.status == OrdersStatus.loading &&
                      state.orders.isEmpty) {
                    return const OrdersLoadingState();
                  }

                  if (state.status == OrdersStatus.failure &&
                      state.orders.isEmpty) {
                    return OrdersErrorState(
                      message: state.errorMessage,
                      onRetry: () => context.read<OrdersCubit>().loadOrders(),
                    );
                  }

                  final filteredOrders =
                      _selectedFilter == OrderFilterValues.all
                      ? state.orders
                      : state.orders
                            .where(
                              (order) =>
                                  order.status.toLowerCase() ==
                                  _selectedFilter,
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return OrderHistoryCard(order: filteredOrders[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
