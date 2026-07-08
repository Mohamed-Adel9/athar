import '../../../../core/failure/api_failure.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  @override
  Future<Result<AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final auth = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _storageService.saveToken(auth.token);
      await _storageService.saveRole(auth.role);
      return Success(auth);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<AuthEntity>> loginGoogle() async {
    try {
      final auth = await _remoteDataSource.loginGoogle();
      await _storageService.saveToken(auth.token);
      await _storageService.saveRole(auth.role);
      return Success(auth);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<AuthEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final auth = await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      await _storageService.saveToken(auth.token);
      await _storageService.saveRole(auth.role);
      return Success(auth);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        await _remoteDataSource.logout();
      }
      await _storageService.clearAuth();
      return const Success(null);
    } catch (error) {
      await _storageService.clearAuth();
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
