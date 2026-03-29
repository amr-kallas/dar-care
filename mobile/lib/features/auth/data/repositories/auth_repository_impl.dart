import 'package:injectable/injectable.dart';
import 'package:dar_care/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository (Domain layer)
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthUser> signUpClient({
    required String email,
    required String password,
    required String fullName,
    required String cityId,
    String? phone,
  }) async {
    return await remoteDataSource.signUpClient(
      email: email,
      password: password,
      fullName: fullName,
      cityId: cityId,
      phone: phone,
    );
  }

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
  }) async {
    return await remoteDataSource.signUpProvider(
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

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<bool> isAuthenticated() async {
    return await remoteDataSource.isAuthenticated();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    return await remoteDataSource.resetPassword(email: email);
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    return await remoteDataSource.updateUserProfile(
      userId: userId,
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }
}
