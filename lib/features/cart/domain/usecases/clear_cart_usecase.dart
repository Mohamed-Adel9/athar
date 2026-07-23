import '../../../../core/utils/result.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase {
  const ClearCartUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<void>> call() {
    return _repository.clearCart();
  }
}
