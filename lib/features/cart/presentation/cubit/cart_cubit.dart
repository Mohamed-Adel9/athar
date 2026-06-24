import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/payment_method.dart';
import '../../data/models/shipping_info_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  //  Navigation

  void goToCart() => emit(state.copyWith(currentStep: 0, clearError: true));
  void goToShipping() {
    if (state.canProceedToShipping) {
      emit(state.copyWith(currentStep: 1, clearError: true));
    }
  }

  void goToPayment() {
    if (state.canProceedToPayment) {
      emit(state.copyWith(currentStep: 2, clearError: true));
    }
  }

  void goBack() {
    if (state.currentStep > 0) {
      emit(
        state.copyWith(currentStep: state.currentStep - 1, clearError: true),
      );
    }
  }

  //  Cart Items

  void addItem(CartItemModel item) {
    final existingIndex = state.items.indexWhere((i) => i.id == item.id);
    List<CartItemModel> updated;

    if (existingIndex >= 0) {
      updated = [...state.items];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + item.quantity,
      );
    } else {
      updated = [...state.items, item];
    }

    emit(state.copyWith(items: updated));
  }

  void removeItem(String id) {
    emit(state.copyWith(items: state.items.where((i) => i.id != id).toList()));
  }

  void updateQuantity(String id, int quantity) {
    if (quantity < 1) {
      removeItem(id);
      return;
    }

    final updated = state.items.map((item) {
      if (item.id == id) return item.copyWith(quantity: quantity);
      return item;
    }).toList();

    emit(state.copyWith(items: updated));
  }

  void incrementQuantity(String id) {
    final item = state.items.firstWhere((i) => i.id == id);
    updateQuantity(id, item.quantity + 1);
  }

  void decrementQuantity(String id) {
    final item = state.items.firstWhere((i) => i.id == id);
    updateQuantity(id, item.quantity - 1);
  }

  //  Promo Code

  void applyPromoCode(String code) {
    // TODO: Replace with real API validation
    if (code.toLowerCase() == 'discount10') {
      emit(state.copyWith(promoCode: code, discount: state.subtotal * 0.1));
    } else {
      emit(
        state.copyWith(
          promoCode: code,
          discount: 0,
          errorMessage: 'كود الخصم غير صالح',
        ),
      );
    }
  }

  //  Shipping

  void updateShippingInfo(ShippingInfoModel info) {
    emit(state.copyWith(shippingInfo: info, clearError: true));
  }

  //  Payment

  void selectPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(paymentMethod: method));
  }

  //  Order

  Future<void> placeOrder() async {
    if (!state.canPlaceOrder) return;

    emit(state.copyWith(status: CartStatus.loading));

    // TODO: Replace with real API call
    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: CartStatus.success,
        currentStep: 3,
        items: [],
        promoCode: '',
        discount: 0,
      ),
    );
  }

  void reset() => emit(const CartState());
}
