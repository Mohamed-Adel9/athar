import 'package:athar/features/wishlist/presentation/cubit/wishlist_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/wishlist_item_model.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit()
    : super(
        WishlistState(
          items: const [
            WishlistItemModel(
              id: 1,
              title: 'تيشرت بولو ابيض',
              price: 299,
              inStock: true,
              image: 'assets/images/onboarding1.png',
            ),
            WishlistItemModel(
              id: 2,
              title: 'تيشرت بولو ابيض',
              price: 599,
              image: "assets/images/onboarding1.png",
              inStock: true,
            ),
            WishlistItemModel(
              id: 3,
              title: 'تيشرت بولو ابيض',
              price: 349,
              image: "assets/images/onboarding1.png",
              inStock: false,
            ),
            WishlistItemModel(
              id: 4,
              title: 'تيشرت بولو ابيض',
              price: 399,
              image: "assets/images/onboarding1.png",
              inStock: true,
            ),
            WishlistItemModel(
              id: 2,
              title: 'تيشرت بولو ابيض',
              price: 599,
              image: "assets/images/onboarding1.png",
              inStock: true,
            ),
            WishlistItemModel(
              id: 3,
              title: 'تيشرت بولو ابيض',
              price: 349,
              image: "assets/images/onboarding1.png",
              inStock: false,
            ),
            WishlistItemModel(
              id: 4,
              title: 'تيشرت بولو ابيض',
              price: 399,
              image: "assets/images/onboarding1.png",
              inStock: true,
            ),
          ],
        ),
      );

  void removeItem(int id) {
    final updated = state.items.where((element) => element.id != id).toList();

    emit(state.copyWith(items: updated));
  }

  void addToCart(WishlistItemModel item) {}
}
