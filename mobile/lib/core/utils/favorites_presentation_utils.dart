import 'package:dar_care/core/utils/provider_presentation_utils.dart';

class FavoritesPresentationUtils {
  static String get mockDistanceKm => ProviderPresentationUtils.mockDistanceKm;

  static String hourlyRateText(double? hourlyRate) {
    return ProviderPresentationUtils.hourlyRateText(hourlyRate);
  }
}
