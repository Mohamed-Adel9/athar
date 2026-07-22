import 'package:flutter/material.dart';

import '../../../../core/const_data/api_urls.dart';

class TemplateModel {
  final String id;
  final String title;
  final IconData icon;
  final bool selected;
  final String? imageUrl;

  const TemplateModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.selected,
    this.imageUrl,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: (json['id'] ?? '').toString(),
      title: json['name']?.toString() ?? json['title']?.toString() ?? '',
      icon: Icons.auto_awesome_rounded,
      selected: false,
      imageUrl: _mediaUrl(json['image']?.toString()),
    );
  }

  TemplateModel copyWith({
    String? id,
    String? title,
    IconData? icon,
    bool? selected,
    String? imageUrl,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      selected: selected ?? this.selected,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'selected': selected,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TemplateModel(id: $id, title: $title)';
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
