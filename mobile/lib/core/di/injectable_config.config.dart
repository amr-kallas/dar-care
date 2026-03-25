// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dar_care/core/di/register_module.dart' as _i795;
import 'package:dar_care/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import 'package:dar_care/features/auth/data/repositories/auth_repository_impl.dart'
    as _i192;
import 'package:dar_care/features/auth/data/repositories/department_repository_impl.dart'
    as _i113;
import 'package:dar_care/features/auth/domain/repositories/auth_repository.dart'
    as _i287;
import 'package:dar_care/features/auth/domain/repositories/department_repository.dart'
    as _i129;
import 'package:dar_care/features/auth/domain/usecases/get_current_user_use_case.dart'
    as _i481;
import 'package:dar_care/features/auth/domain/usecases/get_departments_use_case.dart'
    as _i687;
import 'package:dar_care/features/auth/domain/usecases/sign_in_use_case.dart'
    as _i679;
import 'package:dar_care/features/auth/domain/usecases/sign_out_use_case.dart'
    as _i818;
import 'package:dar_care/features/auth/domain/usecases/sign_up_use_case.dart'
    as _i547;
import 'package:dar_care/features/auth/presentation/cubit/auth_cubit.dart'
    as _i184;
import 'package:dar_care/features/auth/presentation/cubit/department_cubit.dart'
    as _i183;
import 'package:dar_care/features/favorites/data/repositories/favorites_repository_impl.dart'
    as _i369;
import 'package:dar_care/features/favorites/domain/repositories/favorites_repository.dart'
    as _i607;
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart'
    as _i919;
import 'package:dar_care/features/home/client/data/repositories/home_repository_impl.dart'
    as _i799;
import 'package:dar_care/features/home/client/domain/repositories/home_repository.dart'
    as _i8;
import 'package:dar_care/features/home/client/presentation/cubit/home_cubit.dart'
    as _i608;
import 'package:dar_care/features/orders/data/repositories/orders_repository_impl.dart'
    as _i862;
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart'
    as _i75;
import 'package:dar_care/features/orders/presentation/cubit/orders_cubit.dart'
    as _i470;
import 'package:dar_care/features/search/data/repositories/search_repository_impl.dart'
    as _i997;
import 'package:dar_care/features/search/domain/repositories/search_repository.dart'
    as _i484;
import 'package:dar_care/features/search/presentation/cubit/search_cubit.dart'
    as _i777;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.factory<_i107.AuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i129.DepartmentRepository>(
      () => _i113.DepartmentRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i687.GetDepartmentsUseCase>(
      () => _i687.GetDepartmentsUseCase(gh<_i129.DepartmentRepository>()),
    );
    gh.lazySingleton<_i75.OrdersRepository>(
      () => _i862.OrdersRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i183.DepartmentCubit>(
      () => _i183.DepartmentCubit(gh<_i687.GetDepartmentsUseCase>()),
    );
    gh.lazySingleton<_i484.SearchRepository>(
      () => _i997.SearchRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i8.HomeRepository>(
      () => _i799.HomeRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i607.FavoritesRepository>(
      () => _i369.FavoritesRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i470.OrdersCubit>(
      () => _i470.OrdersCubit(gh<_i75.OrdersRepository>()),
    );
    gh.factory<_i919.FavoritesCubit>(
      () => _i919.FavoritesCubit(gh<_i607.FavoritesRepository>()),
    );
    gh.factory<_i287.AuthRepository>(
      () => _i192.AuthRepositoryImpl(
        remoteDataSource: gh<_i107.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i608.HomeCubit>(
      () => _i608.HomeCubit(gh<_i8.HomeRepository>()),
    );
    gh.factory<_i777.SearchCubit>(
      () => _i777.SearchCubit(gh<_i484.SearchRepository>()),
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
    gh.factory<_i481.GetCurrentUserUseCase>(
      () => _i481.GetCurrentUserUseCase(gh<_i287.AuthRepository>()),
    );
    gh.factory<_i184.AuthCubit>(
      () => _i184.AuthCubit(
        signUpUseCase: gh<_i547.SignUpUseCase>(),
        signInUseCase: gh<_i679.SignInUseCase>(),
        signOutUseCase: gh<_i818.SignOutUseCase>(),
        getCurrentUserUseCase: gh<_i481.GetCurrentUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i795.RegisterModule {}
