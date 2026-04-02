import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import '../cubit/provider_home_cubit.dart';
import '../cubit/provider_home_state.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderHomeCubit, ProviderHomeState>(
      listenWhen: (previous, current) =>
          previous.errorMessageKey != current.errorMessageKey &&
          current.errorMessageKey != null,
      listener: (context, state) {
        AppSnackbar.showError(context, state.errorMessageKey!.tr());
      },
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          appBar: CustomAppBar(
            showBackButton: false,
            title: 'provider_dashboard_title'.tr(),
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<ProviderHomeCubit>().loadDashboard(),
            child: _ProviderHomeBody(state: state),
          ),
        );
      },
    );
  }
}

class _ProviderHomeBody extends StatelessWidget {
  const _ProviderHomeBody({required this.state});

  final ProviderHomeState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == ProviderHomeStatus.loading) {
      return const AppLoadingIndicator();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  state.isAvailable ? 'available_now'.tr() : 'unavailable'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch.adaptive(
                value: state.isAvailable,
                onChanged: state.isUpdatingAvailability
                    ? null
                    : (value) => context
                          .read<ProviderHomeCubit>()
                          .toggleAvailability(value),
                activeThumbColor: AppColors.brightGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SummaryCard(state: state),
        const SizedBox(height: 20),
        Text(
          'provider_latest_orders'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (state.pendingOrders.isEmpty)
          _NoPendingOrdersCard()
        else
          ...state.pendingOrders.map((order) => _PendingOrderCard(order: order)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});

  final ProviderHomeState state;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF15392D), Color(0xFF0E2A21)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Colors.white, Color(0xFFF1F7F4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: SolarLinearIcons.wallet,
              title: 'provider_total_earnings'.tr(),
              value: '\$${state.totalEarnings.toStringAsFixed(0)}',
            ),
          ),
          Expanded(
            child: _SummaryItem(
              icon: SolarLinearIcons.checkCircle,
              title: 'provider_completed_jobs'.tr(),
              value: state.completedJobs.toString(),
            ),
          ),
          Expanded(
            child: _SummaryItem(
              icon: SolarLinearIcons.star,
              title: 'provider_average_rating'.tr(),
              value: state.averageRating.toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.brightGreen, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.offBlack,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white70 : AppColors.mediumGrey,
          ),
        ),
      ],
    );
  }
}

class _NoPendingOrdersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Text(
        'provider_no_pending_orders'.tr(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _PendingOrderCard extends StatelessWidget {
  const _PendingOrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brightGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              SolarLinearIcons.calendar,
              color: AppColors.brightGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders_item_title'.tr(namedArgs: {'id': order.id}),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  OrderPresentationUtils.formatServiceDate(
                    context,
                    order.serviceDate,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if ((order.notes ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    order.notes!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC94D).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'orders_filter_pending'.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFB98000),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
