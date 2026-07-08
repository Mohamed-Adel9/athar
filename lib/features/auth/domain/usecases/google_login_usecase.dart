import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  const GoogleLoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthEntity>> call() {
    return _repository.loginGoogle();
  }
}
