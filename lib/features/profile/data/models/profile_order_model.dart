class ProfileOrderModel {
  const ProfileOrderModel({
    required this.id,
    required this.status,
    required this.total,
    this.createdAt,
    this.itemsCount = 0,
  });

  final int id;
  final String status;
  final double total;
  final String? createdAt;
  final int itemsCount;

  factory ProfileOrderModel.fromJson(Map<String, dynamic> json) {
    return ProfileOrderModel(
      id: _int(json['id']),
      status: json['status']?.toString() ?? '',
      total: _double(json['total']),
      createdAt: json['created_at']?.toString(),
      itemsCount: _int(json['items_count'] ?? json['itemsCount']),
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
