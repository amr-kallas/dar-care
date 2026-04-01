import 'package:dar_care/features/orders/presentation/widgets/orders_list_section.dart';
import 'package:dar_care/features/orders/presentation/widgets/orders_status_filter_tabs.dart';
import 'package:flutter/material.dart';

class OrdersScreenContent extends StatelessWidget {
  const OrdersScreenContent({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          OrdersStatusFilterTabs(
            selectedFilter: selectedFilter,
            onChanged: onFilterChanged,
          ),
          const SizedBox(height: 16),
          Expanded(child: OrdersListSection(selectedFilter: selectedFilter)),
        ],
      ),
    );
  }
}
