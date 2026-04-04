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
import 'package:dar_care/features/auth/domain/usecases/sync_fcm_token_use_case.dart'
    as _i619;
import 'package:dar_care/features/auth/domain/usecases/update_user_profile_use_case.dart'
    as _i839;
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart'
    as _i321;
import 'package:dar_care/features/auth/presentation/cubit/department/department_cubit.dart'
    as _i118;
import 'package:dar_care/features/chat/data/datasources/chat_remote_data_source.dart'
    as _i977;
import 'package:dar_care/features/chat/data/repositories/chat_repository_impl.dart'
    as _i78;
import 'package:dar_care/features/chat/domain/repositories/chat_repository.dart'
    as _i900;
import 'package:dar_care/features/chat/presentation/cubit/chat_cubit.dart'
    as _i673;
import 'package:dar_care/features/favorites/data/repositories/favorites_repository_impl.dart'
    as _i369;
import 'package:dar_care/features/favorites/domain/repositories/favorites_repository.dart'
    as _i607;
import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart'
    as _i919;
import 'package:dar_care/features/home/data/repositories/home_repository_impl.dart'
    as _i668;
import 'package:dar_care/features/home/domain/repositories/home_repository.dart'
    as _i59;
import 'package:dar_care/features/home/presentation/client/cubit/home_cubit.dart'
    as _i253;
import 'package:dar_care/features/home/presentation/client/cubit/sub_categories/sub_categories_cubit.dart'
    as _i749;
import 'package:dar_care/features/notifications/data/datasources/notification_remote_data_source.dart'
    as _i862;
import 'package:dar_care/features/notifications/data/repositories/notification_repository_impl.dart'
    as _i859;
import 'package:dar_care/features/notifications/domain/repositories/notification_repository.dart'
    as _i965;
import 'package:dar_care/features/notifications/domain/usecases/notification_session_use_case.dart'
    as _i686;
import 'package:dar_care/features/orders/data/repositories/orders_repository_impl.dart'
    as _i862;
import 'package:dar_care/features/orders/domain/repositories/orders_repository.dart'
    as _i75;
import 'package:dar_care/features/orders/presentation/client/cubit/orders_cubit.dart'
    as _i692;
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
    gh.lazySingleton<_i977.ChatRemoteDataSource>(
      () => _i977.ChatRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i687.GetDepartmentsUseCase>(
      () => _i687.GetDepartmentsUseCase(gh<_i129.DepartmentRepository>()),
    );
    gh.lazySingleton<_i75.OrdersRepository>(
      () => _i862.OrdersRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i118.DepartmentCubit>(
      () => _i118.DepartmentCubit(gh<_i687.GetDepartmentsUseCase>()),
    );
    gh.lazySingleton<_i862.NotificationRemoteDataSource>(
      () => _i862.FirebaseNotificationRemoteDataSource(),
    );
    gh.lazySingleton<_i900.ChatRepository>(
      () => _i78.ChatRepositoryImpl(gh<_i977.ChatRemoteDataSource>()),
    );
    gh.lazySingleton<_i59.HomeRepository>(
      () => _i668.HomeRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i484.SearchRepository>(
      () => _i997.SearchRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i607.FavoritesRepository>(
      () => _i369.FavoritesRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i692.OrdersCubit>(
      () => _i692.OrdersCubit(gh<_i75.OrdersRepository>()),
    );
    gh.factory<_i919.FavoritesCubit>(
      () => _i919.FavoritesCubit(gh<_i607.FavoritesRepository>()),
    );
    gh.lazySingleton<_i965.NotificationRepository>(
      () => _i859.NotificationRepositoryImpl(
        gh<_i862.NotificationRemoteDataSource>(),
      ),
    );
    gh.factory<_i287.AuthRepository>(
      () => _i192.AuthRepositoryImpl(
        remoteDataSource: gh<_i107.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i777.SearchCubit>(
      () => _i777.SearchCubit(gh<_i484.SearchRepository>()),
    );
    gh.factory<_i253.HomeCubit>(
      () => _i253.HomeCubit(gh<_i59.HomeRepository>()),
    );
    gh.factory<_i749.SubCategoriesCubit>(
      () => _i749.SubCategoriesCubit(gh<_i59.HomeRepository>()),
    );
    gh.factory<_i673.ChatCubit>(
      () => _i673.ChatCubit(gh<_i900.ChatRepository>()),
    );
    gh.factory<_i481.GetCurrentUserUseCase>(
      () => _i481.GetCurrentUserUseCase(gh<_i287.AuthRepository>()),
    );
    gh.factory<_i679.SignInUseCase>(
      () => _i679.SignInUseCase(gh<_i287.AuthRepository>()),
    );
    gh.factory<_i818.SignOutUseCase>(
      () => _i818.SignOutUseCase(gh<_i287.AuthRepository>()),
    );
    gh.factory<_i547.SignUpUseCase>(
      () => _i547.SignUpUseCase(gh<_i287.AuthRepository>()),
    );
    gh.factory<_i619.SyncFcmTokenUseCase>(
      () => _i619.SyncFcmTokenUseCase(gh<_i287.AuthRepository>()),
    );
    gh.factory<_i839.UpdateUserProfileUseCase>(
      () => _i839.UpdateUserProfileUseCase(gh<_i287.AuthRepository>()),
    );
    gh.factory<_i321.AuthCubit>(
      () => _i321.AuthCubit(
        signUpUseCase: gh<_i547.SignUpUseCase>(),
        signInUseCase: gh<_i679.SignInUseCase>(),
        signOutUseCase: gh<_i818.SignOutUseCase>(),
        getCurrentUserUseCase: gh<_i481.GetCurrentUserUseCase>(),
        updateUserProfileUseCase: gh<_i839.UpdateUserProfileUseCase>(),
        syncFcmTokenUseCase: gh<_i619.SyncFcmTokenUseCase>(),
        notificationRepository: gh<_i965.NotificationRepository>(),
      ),
    );
    gh.factory<_i686.NotificationSessionUseCase>(
      () => _i686.NotificationSessionUseCase(
        gh<_i965.NotificationRepository>(),
        gh<_i619.SyncFcmTokenUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i795.RegisterModule {}
