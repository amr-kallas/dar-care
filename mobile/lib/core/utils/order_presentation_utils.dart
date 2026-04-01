import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class OrderFilterValues {
  static const String all = 'all';
  static const String pending = 'pending';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
}

class OrderPresentationUtils {
  static String normalizeStatus(String status) => status.toLowerCase();

  static bool matchesFilter({
    required String orderStatus,
    required String selectedFilter,
  }) {
    if (selectedFilter == OrderFilterValues.all) return true;
    return normalizeStatus(orderStatus) == selectedFilter;
  }

  static String statusLocaleKey(String orderStatus) {
    final normalized = normalizeStatus(orderStatus);
    if (normalized == OrderFilterValues.completed) {
      return LocaleKeys.order_status_completed;
    }
    if (normalized == OrderFilterValues.cancelled) {
      return LocaleKeys.order_status_cancelled;
    }
    if (normalized == OrderFilterValues.pending) {
      return LocaleKeys.order_status_pending;
    }
    return LocaleKeys.order_status_confirmed;
  }

  static bool isCancelled(String orderStatus) {
    return normalizeStatus(orderStatus) == OrderFilterValues.cancelled;
  }

  static bool isCompleted(String orderStatus) {
    return normalizeStatus(orderStatus) == OrderFilterValues.completed;
  }

  static Color statusColor(String orderStatus) {
    if (isCancelled(orderStatus)) return const Color(0xFFFF6B6B);
    if (isCompleted(orderStatus)) return AppColors.brightGreen;
    return const Color(0xFFFFC94D);
  }

  static String actionLocaleKey(String orderStatus) {
    return isCancelled(orderStatus)
        ? LocaleKeys.orders_action_view_details
        : LocaleKeys.orders_action_repeat;
  }

  static String formatServiceDate(BuildContext context, DateTime dateTime) {
    final localeCode = context.locale.languageCode;
    return DateFormat('d MMM y - hh:mm a', localeCode).format(dateTime);
  }
}
