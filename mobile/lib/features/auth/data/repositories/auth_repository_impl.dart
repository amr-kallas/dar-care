import 'package:dar_care/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Implementation of AuthRepository (Domain layer)
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<AuthUser> signUpClient({
    required String email,
    required String password,
    required String fullName,
    required String cityId,
    String? phone,
  }) => _remoteDataSource.signUpClient(
    email: email,
    password: password,
    fullName: fullName,
    cityId: cityId,
    phone: phone,
  );

  @override
  Future<AuthUser> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cityId,
    required String departmentId,
    required int experienceYears,
    String? bio,
  }) => _remoteDataSource.signUpProvider(
    email: email,
    password: password,
    fullName: fullName,
    phone: phone,
    cityId: cityId,
    departmentId: departmentId,
    experienceYears: experienceYears,
    bio: bio,
  );

  @override
  Future<AuthUser> signIn({required String email, required String password}) =>
      _remoteDataSource.signIn(email: email, password: password);

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<AuthUser?> getCurrentUser() => _remoteDataSource.getCurrentUser();

  @override
  Future<bool> isAuthenticated() => _remoteDataSource.isAuthenticated();

  @override
  Future<void> resetPassword({required String email}) =>
      _remoteDataSource.resetPassword(email: email);

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) => _remoteDataSource.updateUserProfile(
    userId: userId,
    fullName: fullName,
    phone: phone,
    avatarUrl: avatarUrl,
  );

  @override
  Stream<AuthUser?> authStateChanges() => _remoteDataSource.authStateChanges();
}
