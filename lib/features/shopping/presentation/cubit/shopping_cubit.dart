import 'package:athar/features/shopping/presentation/cubit/shopping_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_category.dart';
import '../../data/models/product_color.dart';
import '../../data/models/product_feature.dart';
import '../../data/models/product_model.dart';
import '../../data/models/product_review.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  ShoppingCubit() : super(const ShoppingState()) {
    _loadProducts();
  }

  final reviewController = TextEditingController();

  void _loadProducts() {
    // TODO: Replace with API call
    final mockProducts = [
      ProductModel(
        id: '1',
        name: 'تيشيرت عربي فاخر',
        description:
            'تيشيرت قطن 100% بتصميم عربي فريد وجودة عالية. مناسب لجميع المناسبات.',
        price: 299,
        originalPrice: 399,
        imageUrl: 'assets/images/design/t-shirt.png',
        category: ProductCategory.tshirts,
        rating: 4.8,
        reviewCount: 234,
        colors: const [
          ProductColor(name: 'أسود', color: Colors.black),
          ProductColor(name: 'أبيض', color: Colors.white),
          ProductColor(name: 'أزرق', color: Colors.blue),
          ProductColor(name: 'بنفسجي', color: Colors.purple),
        ],
        sizes: const ['S', 'M', 'L', 'XL', 'XXL'],
        isNew: true,
        discountPercent: 25,
        features: const [
          ProductFeature(
            icon: Icons.local_shipping_outlined,
            title: 'توصيل سريع',
            subtitle: '2-3 أيام',
          ),
          ProductFeature(
            icon: Icons.verified_outlined,
            title: 'ضمان الجودة',
            subtitle: '100%',
          ),
          ProductFeature(
            icon: Icons.replay_outlined,
            title: 'استرجاع سهل',
            subtitle: '14 يوم',
          ),
        ],
        reviews: const [
          ProductReview(
            userName: 'أحمد محمد',
            userImage: 'assets/images/onboarding1.png',
            date: '2024-03-15',
            rating: 5,
            comment: 'جودة ممتازة وتصميم رائع!',
          ),
        ],
      ),
      ProductModel(
        id: '2',
        name: 'كوب سيراميك مخصص',
        description: 'كوب سيراميك عالي الجودة يحتفظ بالحرارة.',
        price: 149,
        originalPrice: 199,
        imageUrl: 'assets/images/design/mug.png',
        category: ProductCategory.mugs,
        rating: 4.5,
        reviewCount: 89,
        colors: const [ProductColor(name: 'أبيض', color: Colors.white)],
        sizes: const ['250ml', '350ml', '500ml'],
        isNew: false,
        discountPercent: 0,
        features: const [
          ProductFeature(
            icon: Icons.local_shipping_outlined,
            title: 'توصيل سريع',
            subtitle: '2-3 أيام',
          ),
        ],
        reviews: const [],
      ),
      ProductModel(
        id: '3',
        name: 'هودي شتوي فاخر',
        description: 'هودي دافئ للشتاء بتصميم عصري.',
        price: 499,
        originalPrice: 649,
        imageUrl: 'assets/images/design/hoodie.png',
        category: ProductCategory.hoodies,
        rating: 4.9,
        reviewCount: 156,
        colors: const [ProductColor(name: 'رمادي', color: Colors.grey)],
        sizes: const ['S', 'M', 'L', 'XL'],
        isNew: false,
        discountPercent: 23,
        features: const [],
        reviews: const [],
      ),
    ];
    emit(
      state.copyWith(
        products: mockProducts,
        filteredProducts: mockProducts,
        status: ShopStatus.success,
      ),
    );
  }

  //  Filter

  void selectCategory(ProductCategory category) {
    final filtered = category == ProductCategory.all
        ? state.products
        : state.products.where((p) => p.category == category).toList();

    emit(
      state.copyWith(
        selectedCategory: category,
        filteredProducts: _sortProducts(filtered, state.sortBy),
      ),
    );
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

  //  Product Details

  void selectProduct(ProductModel product) {
    emit(
      state.copyWith(
        selectedProduct: product,
        selectedColor: product.colors.first,
        selectedSize: product.sizes.first,
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

  //  Cart

  Map<String, dynamic> getCartItem() {
    if (!state.canAddToCart) return {};

    return {
      'id':
          '${state.selectedProduct!.id}-${state.selectedColor!.name}-${state.selectedSize}',
      'name': state.selectedProduct!.name,
      'price': state.selectedProduct!.price,
      'quantity': state.quantity,
      'imageUrl': state.selectedColor!.color,
      'color': state.selectedColor!.name,
      'size': state.selectedSize,
    };
  }

  // rating

  void changeRating(int rating) {
    emit(state.copyWith(selectedRating: rating));
  }

  void addReview() {
    if (state.selectedProduct == null) return;

    // Use the CUBIT's reviewController, not state's
    if (reviewController.text.trim().isEmpty) return;

    final review = ProductReview(
      userName: 'أنت',
      userImage: 'assets/images/onboarding1.png',
      rating: state.selectedRating?.toDouble() ?? 5, // Safe fallback
      comment: reviewController.text.trim(),
      date: 'الآن',
    );

    final updatedProduct = state.selectedProduct!.copyWith(
      reviews: [...state.selectedProduct!.reviews, review],
    );

    // Clear the cubit's controller
    reviewController.clear();

    emit(state.copyWith(selectedProduct: updatedProduct, selectedRating: 5));
  }
}
