import 'package:athar/features/auth/data/models/auth_model.dart';

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
    return _authenticate(
      () => _remoteDataSource.login(email: email, password: password),
    );
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
    return _authenticate(
      () => _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
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

  @override
  Future<Result<AuthEntity>> loginGoogle() async {
    return _authenticate(_remoteDataSource.loginGoogle);
  }

  @override
  Future<Result<AuthEntity?>> restoreSession() async {
    try {
      final token = await _storageService.getToken();
      if (token == null || token.isEmpty) {
        return const Success(null);
      }

      final auth = await _remoteDataSource.currentUser(token: token);
      await _storageService.saveRole(auth.role);
      return Success(auth);
    } catch (error) {
      await _storageService.clearAuth();
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  Future<Result<AuthEntity>> _authenticate(
    Future<AuthModel> Function() request,
  ) async {
    try {
      final auth = await request();
      await _storageService.saveToken(auth.token);
      await _storageService.saveRole(auth.role);
      return Success(auth);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
