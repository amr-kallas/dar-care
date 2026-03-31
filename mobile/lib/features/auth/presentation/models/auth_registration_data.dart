import 'package:dar_care/features/auth/data/models/app_city.dart';
import 'package:dar_care/features/auth/domain/entities/department.dart';

/// Preloaded lookup data used by signup flows.
class AuthRegistrationData {
  const AuthRegistrationData({required this.cities, required this.departments});

  final List<AppCity> cities;
  final List<Department> departments;
}
