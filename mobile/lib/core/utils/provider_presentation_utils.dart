import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProviderPresentationUtils {
  static const String mockDistanceKm = '2.5';

  static String hourlyRateText(double? hourlyRate) {
    if (hourlyRate == null) return LocaleKeys.price_on_request.tr();
    return '\$${hourlyRate.toStringAsFixed(0)}/hr';
  }
}

