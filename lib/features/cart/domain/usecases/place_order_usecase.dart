import '../../../../core/utils/result.dart';
import '../repositories/cart_repository.dart';

class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<void>> call(Map<String, dynamic> data) {
    return _repository.placeOrder(data);
  }
}
