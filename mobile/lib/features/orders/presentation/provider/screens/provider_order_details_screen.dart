import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/localized_db_text.dart';
import 'package:dar_care/core/utils/order_presentation_utils.dart';
import 'package:dar_care/core/widgets/app_primary_button.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/presentation/provider/screens/provider_chat_screen.dart';
import 'package:dar_care/features/orders/data/models/order_model.dart';
import 'package:dar_care/features/orders/presentation/provider/cubit/provider_order_details_cubit.dart';
import 'package:dar_care/features/orders/presentation/provider/cubit/provider_order_details_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
          final languageCode = context.locale.languageCode;

          return Scaffold(
            backgroundColor: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            appBar: CustomAppBar(
              title: 'provider_order_details_title'.tr(),
              showBackButton: true,
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              children: [
                _OrderQuickSummaryCard(
                  clientName: _clientName(order),
                  serviceType: _serviceType(order, languageCode),
                  statusText:
                      OrderPresentationUtils.statusLocaleKey(order.status).tr(),
                ),
                const SizedBox(height: 16),
                _SectionTitle(text: 'provider_order_address'.tr()),
                const SizedBox(height: 8),
                _DetailsCard(
                  label: _address(order),
                  value: _hasCoordinates(order)
                      ? 'orders_action_view_details'.tr()
                      : 'orders_no_address'.tr(),
                  onTap: _hasCoordinates(order) ? () => _openAddressMap(order) : null,
                  leadingIcon: SolarLinearIcons.mapPoint,
                ),
                const SizedBox(height: 14),
                _SectionTitle(text: 'provider_order_problem_description'.tr()),
                const SizedBox(height: 8),
                _DetailsCard(
                  label: order.problemDescription ?? 'provider_order_not_available'.tr(),
                  value: '',
                  leadingIcon: SolarLinearIcons.documentText,
                ),
                const SizedBox(height: 14),
                _SectionTitle(text: 'provider_enter_quote'.tr()),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  child: TextField(
                    controller: _quoteController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'provider_enter_quote'.tr(),
                      prefixIcon: const Icon(SolarLinearIcons.wallet),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AppPrimaryButton(
                  label: 'provider_open_chat'.tr(),
                  onPressed: _canOpenChat(order) && !isSubmitting
                      ? () => _openChat(order)
                      : null,
                  variant: AppButtonVariant.outline,
                  icon: const Icon(SolarLinearIcons.chatRoundLine, size: 18),
                ),
                const SizedBox(height: 10),
                AppPrimaryButton(
                  label: 'provider_accept_send_quote'.tr(),
                  onPressed: isSubmitting
                      ? null
                      : () => context
                            .read<ProviderOrderDetailsCubit>()
                            .acceptAndSendQuote(_quoteController.text),
                  isLoading: isSubmitting,
                ),
                const SizedBox(height: 10),
                AppPrimaryButton(
                  label: 'provider_reject_order'.tr(),
                  onPressed: isSubmitting
                      ? null
                      : () =>
                            context.read<ProviderOrderDetailsCubit>().rejectOrder(),
                  variant: AppButtonVariant.destructive,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _clientName(OrderModel order) {
    final value = order.clientName?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }

    return 'home_unknown_user'.tr();
  }

  String _address(OrderModel order) {
    final value = order.locationLabel?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }

    return 'orders_no_address'.tr();
  }

  String _serviceType(OrderModel order, String languageCode) {
    final localized = LocalizedDbText.fromSupabase(order.serviceType).resolve(
      languageCode: languageCode,
      fallbackLanguageCode: 'en',
      emptyValue: '',
    );

    return localized.trim().isNotEmpty
        ? localized.trim()
        : 'provider_order_not_available'.tr();
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

  bool _hasCoordinates(OrderModel order) {
    return order.latitude != null && order.longitude != null;
  }

  void _openAddressMap(OrderModel order) {
    if (!_hasCoordinates(order)) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ProviderOrderAddressMapScreen(
          title: 'provider_order_address'.tr(),
          addressLabel: _address(order),
          latitude: order.latitude!,
          longitude: order.longitude!,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDark ? Colors.white : AppColors.offBlack,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _OrderQuickSummaryCard extends StatelessWidget {
  const _OrderQuickSummaryCard({
    required this.clientName,
    required this.serviceType,
    required this.statusText,
  });

  final String clientName;
  final String serviceType;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.brightGreen,
                child: Icon(SolarLinearIcons.user, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      serviceType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.brightGreen.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: AppColors.brightGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.label,
    required this.value,
    this.onTap,
    this.leadingIcon,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leadingIcon != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                leadingIcon,
                size: 18,
                color: isDark ? Colors.white70 : AppColors.mediumGrey,
              ),
            ),
          if (leadingIcon != null) const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                if (value.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.brightGreen,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: content,
    );
  }
}

class _ProviderOrderAddressMapScreen extends StatelessWidget {
  const _ProviderOrderAddressMapScreen({
    required this.title,
    required this.addressLabel,
    required this.latitude,
    required this.longitude,
  });

  final String title;
  final String addressLabel;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: point,
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.darcare.mobile',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 42,
                      height: 42,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 42,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceDark
                : Colors.white,
            child: Text(
              addressLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
