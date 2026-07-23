import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/admin/data/datasources/admin_remote_data_source.dart';
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/fetch_admin_dashboard_usecase.dart';
import '../../features/admin/presentation/cubit/admin_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/google_login_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/restore_session_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_cart_item_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/domain/usecases/fetch_cart_usecase.dart';
import '../../features/cart/domain/usecases/place_order_usecase.dart';
import '../../features/cart/domain/usecases/remove_cart_item_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_item_usecase.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/designer/presentation/cubit/designer_cubit.dart';
import '../../features/designer/data/datasources/designer_remote_data_source.dart';
import '../../features/designer/data/repositories/designer_repository_impl.dart';
import '../../features/designer/domain/repositories/designer_repository.dart';
import '../../features/designer/domain/usecases/fetch_designer_assets_usecase.dart';
import '../../features/designer/domain/usecases/fetch_saved_designs_usecase.dart';
import '../../features/designer/domain/usecases/save_design_usecase.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/fetch_home_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/fetch_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/shopping/data/datasources/shopping_remote_data_source.dart';
import '../../features/shopping/data/repositories/shopping_repository_impl.dart';
import '../../features/shopping/domain/repositories/shopping_repository.dart';
import '../../features/shopping/domain/usecases/fetch_products_usecase.dart';
import '../../features/shopping/presentation/cubit/shopping_cubit.dart';
import '../network/dio_service.dart';
import '../services/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final googleSignIn = GoogleSignIn.instance;
  if (!kIsWeb) {
    await googleSignIn.initialize();
  }

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(sl()),
  );
  sl.registerLazySingleton<DioService>(() => DioService(sl()));

  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(sl()));
  sl.registerLazySingleton<FetchAdminDashboardUseCase>(
    () => FetchAdminDashboardUseCase(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<GoogleLoginUseCase>(() => GoogleLoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
  sl.registerLazySingleton<RestoreSessionUseCase>(
    () => RestoreSessionUseCase(sl()),
  );

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<FetchHomeUseCase>(() => FetchHomeUseCase(sl()));

  sl.registerLazySingleton<ShoppingRemoteDataSource>(
    () => ShoppingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ShoppingRepository>(
    () => ShoppingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FetchProductsUseCase>(
    () => FetchProductsUseCase(sl()),
  );

  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<FetchCartUseCase>(() => FetchCartUseCase(sl()));
  sl.registerLazySingleton<AddCartItemUseCase>(() => AddCartItemUseCase(sl()));
  sl.registerLazySingleton<ClearCartUseCase>(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(sl()),
  );
  sl.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(sl()),
  );
  sl.registerLazySingleton<PlaceOrderUseCase>(() => PlaceOrderUseCase(sl()));

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FetchProfileUseCase>(
    () => FetchProfileUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );

  sl.registerLazySingleton<DesignerRemoteDataSource>(
    () => DesignerRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DesignerRepository>(
    () => DesignerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FetchDesignerAssetsUseCase>(
    () => FetchDesignerAssetsUseCase(sl()),
  );
  sl.registerLazySingleton<FetchSavedDesignsUseCase>(
    () => FetchSavedDesignsUseCase(sl()),
  );
  sl.registerLazySingleton<SaveDesignUseCase>(() => SaveDesignUseCase(sl()));

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<AdminCubit>(() => AdminCubit(sl()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl()));
  sl.registerFactory<ShoppingCubit>(() => ShoppingCubit(sl()));
  sl.registerFactory<DesignerCubit>(() => DesignerCubit(sl(), sl(), sl()));
  sl.registerFactory<CartCubit>(
    () => CartCubit(sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl(), sl()));
}
