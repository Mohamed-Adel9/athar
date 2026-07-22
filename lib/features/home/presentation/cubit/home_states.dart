import '../../domain/entities/home_entity.dart';
import '../widgets/bottom_nav/bottom_nav_tab.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final String activeCategory;
  final BottomNavTab currentTab;
  final HomeStatus status;
  final HomeDataEntity data;
  final String searchQuery;
  final String? errorMessage;

  HomeState({
    required this.activeCategory,
    required this.currentTab,
    this.status = HomeStatus.initial,
    required this.data,
    this.searchQuery = '',
    this.errorMessage,
  });

  factory HomeState.initial() {
    return HomeState(
      activeCategory: 'all',
      currentTab: BottomNavTab.home,
      data: HomeDataEntity.empty(),
    );
  }

  List<HomeProductEntity> get visibleProducts {
    final normalizedSearch = searchQuery.trim().toLowerCase();
    final selectedCategoryId = int.tryParse(activeCategory);

    return data.products.where((product) {
      final matchesCategory =
          activeCategory == 'all' || product.categoryId == selectedCategoryId;
      final matchesSearch =
          normalizedSearch.isEmpty ||
          product.displayName.toLowerCase().contains(normalizedSearch) ||
          (product.category?.displayTitle.toLowerCase().contains(
                normalizedSearch,
              ) ??
              false);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<HomeProductEntity> get featuredProducts {
    if (data.features.isNotEmpty) return data.features;
    return data.products.where((product) => product.isFeatured).toList();
  }

  HomeState copyWith({
    String? activeCategory,
    BottomNavTab? currentTab,
    HomeStatus? status,
    HomeDataEntity? data,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      activeCategory: activeCategory ?? this.activeCategory,
      currentTab: currentTab ?? this.currentTab,
      status: status ?? this.status,
      data: data ?? this.data,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
