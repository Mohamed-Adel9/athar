import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_category.dart';
import '../../data/models/product_color.dart';
import '../../data/models/product_model.dart';
import '../../data/models/product_review.dart';
import '../../domain/usecases/fetch_products_usecase.dart';
import 'shopping_state.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  ShoppingCubit(this._fetchProductsUseCase) : super(const ShoppingState()) {
    fetchProducts();
  }

  final FetchProductsUseCase _fetchProductsUseCase;
  final reviewController = TextEditingController();

  Future<void> fetchProducts({ProductFilter? filter}) async {
    final selectedFilter = filter ?? state.selectedFilter;
    emit(state.copyWith(status: ShopStatus.loading, clearError: true));

    final result = await _fetchProductsUseCase(filter: selectedFilter);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ShopStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (catalog) {
        emit(
          state.copyWith(
            products: catalog.products,
            filteredProducts: _sortProducts(catalog.products, state.sortBy),
            filters: catalog.filters.isEmpty ? state.filters : catalog.filters,
            selectedFilter: selectedFilter,
            status: ShopStatus.success,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> selectFilter(ProductFilter filter) {
    return fetchProducts(filter: filter);
  }

  void setSortBy(SortBy sort) {
    emit(
      state.copyWith(
        sortBy: sort,
        filteredProducts: _sortProducts(state.filteredProducts, sort),
      ),
    );
  }

  List<ProductModel> _sortProducts(List<ProductModel> products, SortBy sort) {
    final sorted = [...products];
    switch (sort) {
      case SortBy.newest:
        return sorted;
      case SortBy.priceLow:
        return sorted..sort((a, b) => a.price.compareTo(b.price));
      case SortBy.priceHigh:
        return sorted..sort((a, b) => b.price.compareTo(a.price));
      case SortBy.popular:
        return sorted..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
  }

  void toggleViewMode() {
    emit(
      state.copyWith(
        viewMode: state.viewMode == ViewMode.grid
            ? ViewMode.list
            : ViewMode.grid,
      ),
    );
  }

  void selectProduct(ProductModel product) {
    emit(
      state.copyWith(
        selectedProduct: product,
        selectedColor: product.colors.isEmpty ? null : product.colors.first,
        selectedSize: product.sizes.isEmpty ? null : product.sizes.first,
        quantity: 1,
      ),
    );
  }

  void clearSelection() {
    emit(
      state.copyWith(
        clearSelectedProduct: true,
        clearSelectedColor: true,
        clearSelectedSize: true,
        quantity: 1,
      ),
    );
  }

  void selectColor(ProductColor color) {
    emit(state.copyWith(selectedColor: color));
  }

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  Map<String, dynamic> getCartItem() {
    if (!state.canAddToCart) return {};

    return {
      'id':
          '${state.selectedProduct!.id}-${state.selectedColor!.name}-${state.selectedSize}',
      'name': state.selectedProduct!.name,
      'price': state.selectedProduct!.price,
      'quantity': state.quantity,
      'imageUrl': state.selectedProduct!.imageUrl,
      'color': state.selectedColor!.name,
      'size': state.selectedSize,
    };
  }

  void changeRating(int rating) {
    emit(state.copyWith(selectedRating: rating));
  }

  void addReview() {
    if (state.selectedProduct == null) return;
    if (reviewController.text.trim().isEmpty) return;

    final review = ProductReview(
      userName: 'You',
      userImage: 'assets/images/onboarding1.png',
      rating: state.selectedRating?.toDouble() ?? 5,
      comment: reviewController.text.trim(),
      date: 'Now',
    );

    final updatedProduct = state.selectedProduct!.copyWith(
      reviews: [...state.selectedProduct!.reviews, review],
    );

    reviewController.clear();

    emit(state.copyWith(selectedProduct: updatedProduct, selectedRating: 5));
  }

  @override
  Future<void> close() {
    reviewController.dispose();
    return super.close();
  }
}
