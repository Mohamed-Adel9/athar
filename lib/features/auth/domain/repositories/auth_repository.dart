import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Result<AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthEntity>> loginGoogle();

  Future<Result<AuthEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<Result<AuthEntity?>> restoreSession();

  Future<Result<void>> logout();
}
