import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case for user sign up
@injectable
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<AuthUser> signUpClient({
    required String email,
    required String password,
    required String fullName,
    required String cityId,
    String? phone,
  }) => _repository.signUpClient(
    email: email,
    password: password,
    fullName: fullName,
    cityId: cityId,
    phone: phone,
  );

  Future<AuthUser> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cityId,
    required String departmentId,
    required int experienceYears,
    String? bio,
  }) => _repository.signUpProvider(
    email: email,
    password: password,
    fullName: fullName,
    phone: phone,
    cityId: cityId,
    departmentId: departmentId,
    experienceYears: experienceYears,
    bio: bio,
  );
}
