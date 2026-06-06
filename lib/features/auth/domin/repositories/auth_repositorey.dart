import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Result<AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> logout();
}
