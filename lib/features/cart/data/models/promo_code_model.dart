class PromoCodeModel {
  const PromoCodeModel({
    required this.code,
    required this.value,
    required this.isPercentage,
    this.discountAmount,
  });

  final String code;
  final double value;
  final bool isPercentage;
  final double? discountAmount;

  double discountFor(double subtotal) {
    final explicitDiscount = discountAmount;
    if (explicitDiscount != null) {
      return explicitDiscount.clamp(0, subtotal).toDouble();
    }

    final discount = isPercentage ? subtotal * value / 100 : value;
    return discount.clamp(0, subtotal).toDouble();
  }

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    final data = _payload(json);
    if (!_isValid(data)) {
      throw const FormatException('Invalid promo code');
    }

    final code = _string(
      data['code'] ?? data['promo_code'] ?? data['coupon_code'],
    );

    return PromoCodeModel(
      code: code,
      value: _double(
        data['value'] ??
            data['amount'] ??
            data['discount_value'] ??
            data['discount'],
      ),
      isPercentage: _isPercentage(data),
      discountAmount: _nullableDouble(
        data['discount_amount'] ??
            data['discountAmount'] ??
            data['calculated_discount'],
      ),
    );
  }
}

bool _isValid(Map<String, dynamic> data) {
  for (final key in const ['valid', 'success', 'status']) {
    final value = data[key];
    if (value == false || value == 0 || value.toString() == '0') {
      return false;
    }
  }

  final active = data['active'] ?? data['is_active'];
  if (active == false || active == 0 || active.toString() == '0') {
    return false;
  }

  return true;
}

Map<String, dynamic> _payload(Map<String, dynamic> json) {
  final data = _map(json['data']);
  final promo = _map(
    data['promo_code'] ??
        data['promoCode'] ??
        data['coupon'] ??
        json['promo_code'] ??
        json['promoCode'] ??
        json['coupon'],
  );

  if (promo.isNotEmpty) {
    return {
      ...data,
      ...promo,
    };
  }

  return data.isEmpty ? json : data;
}

bool _isPercentage(Map<String, dynamic> data) {
  final type = _string(
    data['type'] ??
        data['discount_type'] ??
        data['value_type'] ??
        data['kind'] ??
        data['unit'],
  ).toLowerCase();

  if (type.contains('percent') || type == '%' || type == 'percentage') {
    return true;
  }
  if (type.contains('fixed') || type.contains('amount') || type == 'le') {
    return false;
  }

  final rawValue = data['value'] ?? data['amount'] ?? data['discount_value'];
  return rawValue?.toString().contains('%') == true;
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

String _string(Object? value) {
  return value?.toString().trim() ?? '';
}

double _double(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  final text =
      value?.toString().replaceAll(RegExp(r'[^0-9\.\-]'), '').trim() ?? '';
  return double.tryParse(text) ?? 0;
}

double? _nullableDouble(Object? value) {
  if (value == null) return null;
  return _double(value);
}
