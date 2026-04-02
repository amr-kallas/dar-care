import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/presentation/provider/screens/provider_chat_screen.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/features/orders/presentation/provider/cubit/provider_order_details_cubit.dart';
import 'package:dar_care/features/orders/presentation/provider/cubit/provider_order_details_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderOrderDetailsScreen extends StatefulWidget {
  const ProviderOrderDetailsScreen({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  State<ProviderOrderDetailsScreen> createState() =>
      _ProviderOrderDetailsScreenState();
}

class _ProviderOrderDetailsScreenState extends State<ProviderOrderDetailsScreen> {
  late final TextEditingController _quoteController;

  @override
  void initState() {
    super.initState();
    _quoteController = TextEditingController(
      text: widget.order.quotedPrice?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => ProviderOrderDetailsCubit(
        getIt(),
        initialState: ProviderOrderDetailsState(order: widget.order),
      ),
      child: BlocConsumer<ProviderOrderDetailsCubit, ProviderOrderDetailsState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessageKey != current.errorMessageKey,
        listener: (context, state) {
          if (state.status == ProviderOrderDetailsStatus.failure &&
              state.errorMessageKey != null) {
            AppSnackbar.showError(context, state.errorMessageKey!.tr());
          }

          if (state.status == ProviderOrderDetailsStatus.success) {
            AppSnackbar.showSuccess(
              context,
              'provider_order_action_success'.tr(),
            );
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final isSubmitting = state.status == ProviderOrderDetailsStatus.submitting;
          final order = state.order;

          return Scaffold(
            backgroundColor: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            appBar: CustomAppBar(
              title: 'provider_order_details_title'.tr(),
              showBackButton: true,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _DetailsCard(
                  label: 'provider_order_client_name'.tr(),
                  value: order.clientName ?? 'home_unknown_user'.tr(),
                ),
                const SizedBox(height: 10),
                _DetailsCard(
                  label: 'provider_order_address'.tr(),
                  value: order.locationLabel ?? 'orders_no_address'.tr(),
                ),
                const SizedBox(height: 10),
                _DetailsCard(
                  label: 'provider_order_service_type'.tr(),
                  value: order.serviceType ?? 'provider_order_not_available'.tr(),
                ),
                const SizedBox(height: 10),
                _DetailsCard(
                  label: 'provider_order_problem_description'.tr(),
                  value:
                      order.problemDescription ?? 'provider_order_not_available'.tr(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _quoteController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'provider_enter_quote'.tr(),
                    prefixIcon: const Icon(SolarLinearIcons.wallet),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _canOpenChat(order) ? () => _openChat(order) : null,
                  icon: const Icon(SolarLinearIcons.chatRoundLine),
                  label: Text('provider_open_chat'.tr()),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () => context
                            .read<ProviderOrderDetailsCubit>()
                            .acceptAndSendQuote(_quoteController.text),
                  child: Text('provider_accept_send_quote'.tr()),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorRed,
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () =>
                            context.read<ProviderOrderDetailsCubit>().rejectOrder(),
                  child: Text('provider_reject_order'.tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _canOpenChat(OrderModel order) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    return currentUserId != null &&
        currentUserId.isNotEmpty &&
        (order.providerId?.isNotEmpty ?? false) &&
        (order.clientId?.isNotEmpty ?? false);
  }

  void _openChat(OrderModel order) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null ||
        currentUserId.isEmpty ||
        order.providerId == null ||
        order.clientId == null) {
      AppSnackbar.showError(context, 'auth_error_generic'.tr());
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProviderChatScreen(
          currentUserId: currentUserId,
          providerId: order.providerId!,
          clientId: order.clientId!,
          title: order.clientName,
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.white70 : AppColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
