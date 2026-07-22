import '../../../../core/utils/result.dart';
import '../../data/models/product_category.dart';
import '../../data/models/product_model.dart';
import '../repositories/shopping_repository.dart';

class FetchProductsUseCase {
  const FetchProductsUseCase(this._repository);

  final ShoppingRepository _repository;

  Future<Result<ProductCatalogModel>> call({ProductFilter? filter}) {
    return _repository.fetchProducts(filter: filter);
  }
}
