import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart';
import 'package:flutter/material.dart';

import 'provider_order_details_screen.dart';

class ProviderOrderDetailsEntryScreen extends StatefulWidget {
  const ProviderOrderDetailsEntryScreen({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  State<ProviderOrderDetailsEntryScreen> createState() =>
      _ProviderOrderDetailsEntryScreenState();
}

class _ProviderOrderDetailsEntryScreenState
    extends State<ProviderOrderDetailsEntryScreen> {
  late final Future<OrderModel> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture =
        getIt<OrdersRepository>().getProviderOrderById(orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order details')),
            body: const Center(
              child: Text('Unable to open this order right now.'),
            ),
          );
        }

        return ProviderOrderDetailsScreen(order: snapshot.data!);
      },
    );
  }
}
