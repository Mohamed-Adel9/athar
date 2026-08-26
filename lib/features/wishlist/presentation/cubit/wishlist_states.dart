import '../../data/models/wishlist_item_model.dart';

enum WishlistStatus { initial, loading, success, error }

class WishlistState {
  final List<WishlistItemModel> items;
  final WishlistStatus status;
  final String? errorMessage;

  const WishlistState({
    required this.items,
    this.status = WishlistStatus.initial,
    this.errorMessage,
  });

  WishlistState copyWith({
    List<WishlistItemModel>? items,
    WishlistStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WishlistState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
