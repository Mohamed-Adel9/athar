import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/google_login_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
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

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl(), sl(), sl(), sl()));
}
