import '../../../../core/failure/api_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../datasources/shopping_remote_data_source.dart';
import '../models/product_category.dart';
import '../models/product_model.dart';

class ShoppingRepositoryImpl implements ShoppingRepository {
  const ShoppingRepositoryImpl(this._remoteDataSource);

  final ShoppingRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ProductCatalogModel>> fetchProducts({
    ProductFilter? filter,
  }) async {
    try {
      final catalog = await _remoteDataSource.fetchProducts(filter: filter);
      return Success(catalog);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
