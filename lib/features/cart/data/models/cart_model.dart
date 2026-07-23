import 'cart_item_model.dart';

class CartModel {
  const CartModel({
    required this.items,
    required this.deliveryFee,
    required this.discount,
  });

  final List<CartItemModel> items;
  final double deliveryFee;
  final double discount;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']).isEmpty ? json : _map(json['data']);
    return CartModel(
      items: _list(data['items']).map(CartItemModel.fromJson).toList(),
      deliveryFee: _double(data['delivery_fee'], 50),
      discount: _double(data['discount'], 0),
    );
  }
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList();
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

double _double(Object? value, double fallback) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}
