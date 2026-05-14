import 'package:flutter/foundation.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/payment_method.dart';
import '../../data/models/shipping_info_model.dart';

enum CartStatus { initial, loading, success, error }

@immutable
class CartState {
  const CartState({
    this.items = const [],
    this.shippingInfo = const ShippingInfoModel(),
    this.paymentMethod = PaymentMethod.cashOnDelivery,
    this.promoCode = '',
    this.discount = 0.0,
    this.deliveryFee = 50.0,
    this.status = CartStatus.initial,
    this.currentStep = 0,
    this.errorMessage,
  });

  final List<CartItemModel> items;
  final ShippingInfoModel shippingInfo;
  final PaymentMethod paymentMethod;
  final String promoCode;
  final double discount;
  final double deliveryFee;
  final CartStatus status;
  final int currentStep; // 0: cart, 1: shipping, 2: payment, 3: success
  final String? errorMessage;

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + deliveryFee - discount;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get canProceedToShipping => items.isNotEmpty;
  bool get canProceedToPayment => shippingInfo.isComplete;
  bool get canPlaceOrder => items.isNotEmpty && shippingInfo.isComplete;

  CartState copyWith({
    List<CartItemModel>? items,
    ShippingInfoModel? shippingInfo,
    PaymentMethod? paymentMethod,
    String? promoCode,
    double? discount,
    double? deliveryFee,
    CartStatus? status,
    int? currentStep,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CartState(
      items: items ?? this.items,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CartState &&
              runtimeType == other.runtimeType &&
              listEquals(items, other.items) &&
              shippingInfo == other.shippingInfo &&
              paymentMethod == other.paymentMethod &&
              promoCode == other.promoCode &&
              discount == other.discount &&
              deliveryFee == other.deliveryFee &&
              status == other.status &&
              currentStep == other.currentStep;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(items),
    shippingInfo,
    paymentMethod,
    promoCode,
    discount,
    deliveryFee,
    status,
    currentStep,
  );
}