import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/utils/app_refresh_notifier.dart';
import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_tabs/custom_tab_item.dart';
import '../../../../../core/widgets/custom_tabs/custom_tabs.dart';
import '../../client/widgets/order_card_display_mode.dart';
import '../../client/widgets/order_history_card.dart';
import '../../client/widgets/orders_empty_state.dart';
import '../../client/widgets/orders_error_state.dart';
import '../../client/widgets/orders_loading_state.dart';
import '../cubit/provider_orders_cubit.dart';
import '../cubit/provider_orders_state.dart';
import 'provider_order_details_entry_screen.dart';

class ProviderOrdersScreen extends StatelessWidget {
  const ProviderOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderOrdersCubit(getIt())..loadOrders(),
      child: const _ProviderOrdersView(),
    );
  }
}

class _ProviderOrdersView extends StatefulWidget {
  const _ProviderOrdersView();

  @override
  State<_ProviderOrdersView> createState() => _ProviderOrdersViewState();
}

class _ProviderOrdersViewState extends State<_ProviderOrdersView> {
  _ProviderOrdersTab _selectedTab = _ProviderOrdersTab.newRequests;
  int _lastOrdersVersion = 0;

  @override
  void initState() {
    super.initState();
    _lastOrdersVersion = appRefreshNotifier.ordersVersion;
    appRefreshNotifier.addListener(_onGlobalRefresh);
  }

  @override
  void dispose() {
    appRefreshNotifier.removeListener(_onGlobalRefresh);
    super.dispose();
  }

  void _onGlobalRefresh() {
    if (!mounted) {
      return;
    }

    if (_lastOrdersVersion == appRefreshNotifier.ordersVersion) {
      return;
    }

    _lastOrdersVersion = appRefreshNotifier.ordersVersion;
    context.read<ProviderOrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<ProviderOrdersCubit, ProviderOrdersState>(
      listenWhen: (previous, current) =>
          previous.errorMessageKey != current.errorMessageKey &&
          current.errorMessageKey != null,
      listener: (context, state) {
        AppSnackbar.showError(context, state.errorMessageKey!.tr());
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: CustomAppBar(
          showBackButton: false,
          title: LocaleKeys.provider_jobs_tab.tr(),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomTabs(
                items: [
                  CustomTabItem(
                    value: _ProviderOrdersTab.newRequests.name,
                    label: LocaleKeys.provider_orders_new_requests.tr(),
                  ),
                  CustomTabItem(
                    value: _ProviderOrdersTab.activeJobs.name,
                    label: LocaleKeys.provider_orders_active_jobs.tr(),
                  ),
                  CustomTabItem(
                    value: _ProviderOrdersTab.history.name,
                    label: LocaleKeys.provider_orders_history.tr(),
                  ),
                ],
                selectedValue: _selectedTab.name,
                onChanged: (value) {
                  setState(() {
                    _selectedTab = _ProviderOrdersTab.values.firstWhere(
                      (tab) => tab.name == value,
                    );
                  });
                },
              ),
            ),
            Expanded(child: _ProviderOrdersTabContent(tab: _selectedTab)),
          ],
        ),
      ),
    );
  }
}

enum _ProviderOrdersTab { newRequests, activeJobs, history }

class _ProviderOrdersTabContent extends StatelessWidget {
  const _ProviderOrdersTabContent({required this.tab});

  final _ProviderOrdersTab tab;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderOrdersCubit, ProviderOrdersState>(
      builder: (context, state) {
        if (state.status == ProviderOrdersStatus.loading &&
            state.orders.isEmpty) {
          return const OrdersLoadingState();
        }

        if (state.status == ProviderOrdersStatus.failure &&
            state.orders.isEmpty) {
          return OrdersErrorState(
            messageKey: state.errorMessageKey,
            onRetry: () => context.read<ProviderOrdersCubit>().loadOrders(),
          );
        }

        final filteredOrders = state.orders
            .where((order) => _matchesTab(order.status, tab))
            .toList(growable: false);

        if (filteredOrders.isEmpty) {
          return const OrdersEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => context.read<ProviderOrdersCubit>().loadOrders(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: filteredOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  final changed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) =>
                          ProviderOrderDetailsEntryScreen(orderId: order.id),
                    ),
                  );

                  if (changed == true && context.mounted) {
                    await context.read<ProviderOrdersCubit>().loadOrders();
                  }
                },
                child: OrderHistoryCard(
                  order: order,
                  displayMode: OrderCardDisplayMode.provider,
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool _matchesTab(String status, _ProviderOrdersTab tab) {
    final normalized = OrderPresentationUtils.normalizeStatus(status);

    switch (tab) {
      case _ProviderOrdersTab.newRequests:
        return normalized == OrderFilterValues.pending;
      case _ProviderOrdersTab.activeJobs:
        return normalized == 'accepted' || normalized == 'in_progress';
      case _ProviderOrdersTab.history:
        return normalized == OrderFilterValues.completed ||
            normalized == OrderFilterValues.cancelled;
    }
  }
}
