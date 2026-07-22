import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/product_category.dart';
import '../models/product_model.dart';

abstract class ShoppingRemoteDataSource {
  Future<ProductCatalogModel> fetchProducts({ProductFilter? filter});
}

class ShoppingRemoteDataSourceImpl implements ShoppingRemoteDataSource {
  const ShoppingRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<ProductCatalogModel> fetchProducts({ProductFilter? filter}) async {
    final response = await _dioService.get(
      url: _urlFor(filter),
      queryParameters: const {
        'page': 1,
      },
    );
    return ProductCatalogModel.fromJson(response.data);
  }

  String _urlFor(ProductFilter? filter) {
    if (filter == null || filter.type == ProductFilterType.all) {
      return ApiUrls.products;
    }

    return switch (filter.type) {
      ProductFilterType.all => ApiUrls.products,
      ProductFilterType.categoryType => ApiUrls.productsByCategoryType(
          filter.id,
        ),
      ProductFilterType.category => ApiUrls.productsByCategory(filter.id),
    };
  }
}
