// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dar_care/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import 'package:dar_care/features/auth/data/repositories/auth_repository_impl.dart'
    as _i192;
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart'
    as _i287;
import 'package:dar_care/features/auth/domain/usecases/sign_in_use_case.dart'
    as _i679;
import 'package:dar_care/features/auth/domain/usecases/sign_out_use_case.dart'
    as _i818;
import 'package:dar_care/features/auth/domain/usecases/sign_up_use_case.dart'
    as _i547;
import 'package:dar_care/features/auth/presentation/cubit/auth_cubit.dart'
    as _i184;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i107.AuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i287.AuthRepository>(
      () => _i192.AuthRepositoryImpl(
        remoteDataSource: gh<_i107.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i679.SignInUseCase>(
      () => _i679.SignInUseCase(repository: gh<_i287.AuthRepository>()),
    );
    gh.factory<_i818.SignOutUseCase>(
      () => _i818.SignOutUseCase(repository: gh<_i287.AuthRepository>()),
    );
    gh.factory<_i547.SignUpUseCase>(
      () => _i547.SignUpUseCase(repository: gh<_i287.AuthRepository>()),
    );
    gh.factory<_i184.AuthCubit>(
      () => _i184.AuthCubit(
        signUpUseCase: gh<_i547.SignUpUseCase>(),
        signInUseCase: gh<_i679.SignInUseCase>(),
        signOutUseCase: gh<_i818.SignOutUseCase>(),
      ),
    );
    return this;
  }
}
