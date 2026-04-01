import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePresentationUtils {
  static const String mockDistanceKm = '2.5';

  static String welcomeName(AuthState state) {
    final user = resolveAuthUser(state);
    final fullName = user?.fullName?.trim();
    if (fullName == null || fullName.isEmpty) {
      return LocaleKeys.home_unknown_user.tr();
    }
    return fullName.split(' ').first;
  }

  static String hourlyRateText(double? hourlyRate) {
    if (hourlyRate == null) return LocaleKeys.price_on_request.tr();
    return '\$${hourlyRate.toStringAsFixed(0)}/hr';
  }
}
