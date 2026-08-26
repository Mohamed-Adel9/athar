import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/wishlist_item_model.dart';
import '../../domain/usecases/add_wishlist_item_usecase.dart';
import '../../domain/usecases/fetch_cached_wishlist_usecase.dart';
import '../../domain/usecases/fetch_wishlist_usecase.dart';
import '../../domain/usecases/remove_wishlist_item_usecase.dart';
import '../../domain/usecases/save_cached_wishlist_usecase.dart';
import 'wishlist_states.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit(
    this._fetchCachedWishlistUseCase,
    this._saveCachedWishlistUseCase,
    this._fetchWishlistUseCase,
    this._addWishlistItemUseCase,
    this._removeWishlistItemUseCase,
  ) : super(const WishlistState(items: []));

  final FetchCachedWishlistUseCase _fetchCachedWishlistUseCase;
  final SaveCachedWishlistUseCase _saveCachedWishlistUseCase;
  final FetchWishlistUseCase _fetchWishlistUseCase;
  final AddWishlistItemUseCase _addWishlistItemUseCase;
  final RemoveWishlistItemUseCase _removeWishlistItemUseCase;

  bool containsItem(int id) {
    return state.items.any((item) => item.id == id);
  }

  Future<void> fetchWishlist() async {
    final cachedItems = await _fetchCachedWishlistUseCase();
    if (cachedItems.isNotEmpty) {
      emit(
        state.copyWith(
          items: _uniqueItems(cachedItems),
          status: WishlistStatus.initial,
          clearError: true,
        ),
      );
    }

    emit(state.copyWith(status: WishlistStatus.loading, clearError: true));

    final result = await _fetchWishlistUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: WishlistStatus.success,
            errorMessage: failure.message,
          ),
        );
      },
      (items) {
        final mergedItems = _uniqueItems([...state.items, ...items]);
        emit(
          state.copyWith(
            items: mergedItems,
            status: WishlistStatus.success,
            clearError: true,
          ),
        );
        unawaited(_saveCachedWishlistUseCase(mergedItems));
      },
    );
  }

  void addItem(WishlistItemModel item) {
    if (containsItem(item.id)) return;
    _setItems([...state.items, item]);
    unawaited(_syncAdd(item));
  }

  void removeItem(int id) {
    final matchingItems = state.items.where((item) => item.id == id);
    if (matchingItems.isEmpty) return;

    final item = matchingItems.first;
    _setItems(state.items.where((item) => item.id != id).toList());
    unawaited(_syncRemove(item));
  }

  bool toggleItem(WishlistItemModel item) {
    if (containsItem(item.id)) {
      removeItem(item.id);
      return false;
    }

    addItem(item);
    return true;
  }

  void _setItems(List<WishlistItemModel> items) {
    final updatedItems = _uniqueItems(items);
    emit(
      state.copyWith(
        items: updatedItems,
        status: WishlistStatus.success,
        clearError: true,
      ),
    );
    unawaited(_saveCachedWishlistUseCase(updatedItems));
  }

  Future<void> _syncAdd(WishlistItemModel item) async {
    final result = await _addWishlistItemUseCase(item);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: WishlistStatus.success,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {},
    );
  }

  Future<void> _syncRemove(WishlistItemModel item) async {
    final result = await _removeWishlistItemUseCase(item);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: WishlistStatus.success,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {},
    );
  }

  List<WishlistItemModel> _uniqueItems(List<WishlistItemModel> items) {
    final uniqueItems = <WishlistItemModel>[];
    for (final item in items) {
      if (uniqueItems.any((current) => current.id == item.id)) continue;
      uniqueItems.add(item);
    }
    return uniqueItems;
  }
}
