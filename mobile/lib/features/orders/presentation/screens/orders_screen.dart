import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:dar_care/features/orders/presentation/widgets/orders_screen_content.dart';
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
      body: OrdersScreenContent(
        selectedFilter: _selectedFilter,
        onFilterChanged: (value) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }
}
