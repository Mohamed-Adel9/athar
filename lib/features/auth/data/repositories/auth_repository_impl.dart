import '../../../../core/failure/api_failure.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../domin/entities/auth_entity.dart';
import '../../domin/repositories/auth_repositorey.dart';
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
      return Success(auth);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final auth = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      await _storageService.saveToken(auth.token);
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
      await _storageService.deleteToken();
      return const Success(null);
    } catch (error) {
      await _storageService.deleteToken();
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
