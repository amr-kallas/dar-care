import 'package:dar_care/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:dar_care/features/orders/presentation/cubit/orders_state.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_care/core/di/injection.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>()..loadOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.orders_screen_placeholder.tr()),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == OrdersStatus.failure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders found'));
            }

            return ListView.separated(
              itemCount: state.orders.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return ListTile(
                  title: Text('Order #${order.id} - ${order.status}'),
                  subtitle: Text(DateFormat.yMMMd().format(order.serviceDate)),
                  trailing: Text(order.status),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

