import 'package:flutter/foundation.dart';

import '../../data/models/product_category.dart';
import '../../data/models/product_color.dart';
import '../../data/models/product_model.dart';

enum ShopStatus { initial, loading, success, error }

enum ViewMode { grid, list }

@immutable
class ShoppingState {
  const ShoppingState({
    this.products = const [],
    this.filteredProducts = const [],
    this.selectedCategory = ProductCategory.all,
    this.selectedProduct,
    this.selectedColor,
    this.selectedSize,
    this.quantity = 1,
    this.viewMode = ViewMode.grid,
    this.sortBy = SortBy.newest,
    this.status = ShopStatus.initial,
    this.errorMessage,
  });

  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final ProductCategory selectedCategory;
  final ProductModel? selectedProduct;
  final ProductColor? selectedColor;
  final String? selectedSize;
  final int quantity;
  final ViewMode viewMode;
  final SortBy sortBy;
  final ShopStatus status;
  final String? errorMessage;

  bool get hasSelection => selectedProduct != null;
  bool get canAddToCart =>
      selectedProduct != null && selectedSize != null && selectedColor != null;

  ShoppingState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    ProductCategory? selectedCategory,
    ProductModel? selectedProduct,
    bool clearSelectedProduct = false,
    ProductColor? selectedColor,
    bool clearSelectedColor = false,
    String? selectedSize,
    bool clearSelectedSize = false,
    int? quantity,
    ViewMode? viewMode,
    SortBy? sortBy,
    ShopStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ShoppingState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedProduct: clearSelectedProduct
          ? null
          : (selectedProduct ?? this.selectedProduct),
      selectedColor: clearSelectedColor
          ? null
          : (selectedColor ?? this.selectedColor),
      selectedSize: clearSelectedSize
          ? null
          : (selectedSize ?? this.selectedSize),
      quantity: quantity ?? this.quantity,
      viewMode: viewMode ?? this.viewMode,
      sortBy: sortBy ?? this.sortBy,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingState &&
          runtimeType == other.runtimeType &&
          listEquals(products, other.products) &&
          listEquals(filteredProducts, other.filteredProducts) &&
          selectedCategory == other.selectedCategory &&
          selectedProduct == other.selectedProduct &&
          selectedColor == other.selectedColor &&
          selectedSize == other.selectedSize &&
          quantity == other.quantity &&
          viewMode == other.viewMode &&
          sortBy == other.sortBy &&
          status == other.status;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(products),
    Object.hashAll(filteredProducts),
    selectedCategory,
    selectedProduct,
    selectedColor,
    selectedSize,
    quantity,
    viewMode,
    sortBy,
    status,
  );
}

enum SortBy { newest, priceLow, priceHigh, popular }
