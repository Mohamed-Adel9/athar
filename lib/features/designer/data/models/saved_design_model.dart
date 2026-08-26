import 'dart:convert';

class SavedDesignModel {
  const SavedDesignModel({
    required this.id,
    required this.name,
    this.previewImage,
    this.productName,
    this.templateName,
    this.createdAt,
    this.designData = const {},
  });

  final int id;
  final String name;
  final String? previewImage;
  final String? productName;
  final String? templateName;
  final String? createdAt;
  final Map<String, dynamic> designData;

  factory SavedDesignModel.fromJson(Map<String, dynamic> json) {
    return SavedDesignModel(
      id: _int(json['id']),
      name: json['name']?.toString() ?? 'تصميم محفوظ',
      previewImage:
          json['preview_image_url']?.toString() ??
          json['preview_image']?.toString() ??
          json['previewImageUrl']?.toString() ??
          json['previewImage']?.toString() ??
          json['image_url']?.toString() ??
          json['image']?.toString(),
      productName: _localized(_map(json['product'])['name']),
      templateName:
          _map(json['design'])['name']?.toString() ??
          _map(json['desgin'])['name']?.toString(),
      createdAt: json['created_at']?.toString(),
      designData: _nullableMap(json['design_data']),
    );
  }
}

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

Map<String, dynamic> _nullableMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }
  return const {};
}

String? _localized(Object? value) {
  if (value is Map<String, dynamic>) {
    return value['ar']?.toString() ?? value['en']?.toString();
  }
  return value?.toString();
}
