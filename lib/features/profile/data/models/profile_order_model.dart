class ProfileOrderModel {
  const ProfileOrderModel({
    required this.id,
    required this.status,
    required this.total,
    this.createdAt,
    this.itemsCount = 0,
    this.paymentMethod = '',
    this.paymentStatus = '',
    this.paymentProofUrl,
  });

  final int id;
  final String status;
  final double total;
  final String? createdAt;
  final int itemsCount;
  final String paymentMethod;
  final String paymentStatus;
  final String? paymentProofUrl;

  bool get isInstapayPayment {
    final normalized = paymentMethod.trim().toLowerCase();
    return normalized.contains('instapay') || normalized.contains('insta_pay');
  }

  bool get canAttachPaymentProof => isInstapayPayment;

  ProfileOrderModel copyWith({
    int? id,
    String? status,
    double? total,
    String? createdAt,
    int? itemsCount,
    String? paymentMethod,
    String? paymentStatus,
    String? paymentProofUrl,
  }) {
    return ProfileOrderModel(
      id: id ?? this.id,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      itemsCount: itemsCount ?? this.itemsCount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentProofUrl: paymentProofUrl ?? this.paymentProofUrl,
    );
  }

  factory ProfileOrderModel.fromJson(Map<String, dynamic> json) {
    return ProfileOrderModel(
      id: _int(json['id']),
      status: json['status']?.toString() ?? '',
      total: _double(json['total']),
      createdAt: json['created_at']?.toString(),
      itemsCount: _int(json['items_count'] ?? json['itemsCount']),
      paymentMethod:
          json['payment_provider']?.toString() ??
          json['payment_method']?.toString() ??
          json['paymentProvider']?.toString() ??
          json['paymentMethod']?.toString() ??
          _map(json['payment'])['method']?.toString() ??
          _map(json['payment'])['provider']?.toString() ??
          '',
      paymentStatus:
          json['payment_status']?.toString() ??
          json['paymentStatus']?.toString() ??
          _map(json['payment'])['status']?.toString() ??
          '',
      paymentProofUrl:
          json['payment_proof_url']?.toString() ??
          json['paymentProofUrl']?.toString() ??
          json['payment_proof']?.toString() ??
          _map(json['payment'])['proof_url']?.toString(),
    );
  }
}

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _double(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}
