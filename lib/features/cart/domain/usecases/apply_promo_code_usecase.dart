import '../../../../core/utils/result.dart';
import '../../data/models/promo_code_model.dart';
import '../repositories/cart_repository.dart';

class ApplyPromoCodeUseCase {
  const ApplyPromoCodeUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<PromoCodeModel>> call({
    required String code,
    required double subtotal,
  }) {
    return _repository.applyPromoCode(code: code, subtotal: subtotal);
  }
}
