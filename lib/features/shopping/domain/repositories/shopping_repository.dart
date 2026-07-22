import '../../../../core/utils/result.dart';
import '../../data/models/product_category.dart';
import '../../data/models/product_model.dart';

abstract class ShoppingRepository {
  Future<Result<ProductCatalogModel>> fetchProducts({ProductFilter? filter});
}
