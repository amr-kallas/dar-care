import 'package:dar_care/features/auth/data/models/app_city.dart';
import 'package:dar_care/features/auth/data/repositories/city_repository.dart';
import 'package:dar_care/features/auth/domain/usecases/get_departments_use_case.dart';
import 'package:dar_care/features/auth/presentation/models/auth_registration_data.dart';

class AuthRegistrationDataLoader {
  const AuthRegistrationDataLoader({
    required CityRepository cityRepository,
    required GetDepartmentsUseCase getDepartmentsUseCase,
  }) : _cityRepository = cityRepository,
       _getDepartmentsUseCase = getDepartmentsUseCase;

  final CityRepository _cityRepository;
  final GetDepartmentsUseCase _getDepartmentsUseCase;

  Future<List<AppCity>> loadCities({AuthRegistrationData? preloaded}) async {
    if (preloaded != null) {
      return preloaded.cities;
    }

    return _cityRepository.getCities();
  }

  Future<AuthRegistrationData> load({AuthRegistrationData? preloaded}) async {
    if (preloaded != null) {
      return preloaded;
    }

    final citiesFuture = _cityRepository.getCities();
    final departmentsFuture = _getDepartmentsUseCase();

    final cities = await citiesFuture;
    final departments = await departmentsFuture;

    return AuthRegistrationData(cities: cities, departments: departments);
  }
}

