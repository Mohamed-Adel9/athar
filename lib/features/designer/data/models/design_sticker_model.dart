import '../../../../core/const_data/api_urls.dart';

class DesignStickerModel {
  const DesignStickerModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.category,
  });

  final int id;
  final String name;
  final String imageUrl;
  final String? category;

  factory DesignStickerModel.fromJson(Map<String, dynamic> json) {
    return DesignStickerModel(
      id: _int(json['id']),
      name: json['name']?.toString() ?? '',
      imageUrl: _mediaUrl(json['image']?.toString()) ?? '',
      category: json['category']?.toString(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignStickerModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => Object.hash(id, imageUrl);
}

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _mediaUrl(String? path) {
  if (path == null || path.trim().isEmpty) return null;
  final value = path.trim();
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }

  final baseUri = Uri.tryParse(ApiUrls.baseUrl);
  if (baseUri == null || !baseUri.hasScheme || baseUri.host.isEmpty) {
    return null;
  }

  final origin = '${baseUri.scheme}://${baseUri.authority}';
  return value.startsWith('/') ? '$origin$value' : '$origin/$value';
}
