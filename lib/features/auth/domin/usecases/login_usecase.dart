import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repositorey.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
