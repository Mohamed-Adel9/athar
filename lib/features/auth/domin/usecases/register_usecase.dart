import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repositorey.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthEntity>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
