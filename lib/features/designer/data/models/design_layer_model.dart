import 'package:flutter/material.dart';

import 'text_style_model.dart';

enum LayerType { image, text, sticker }

@immutable
class DesignLayerModel {
  const DesignLayerModel({
    required this.id,
    required this.type,
    required this.name,
    required this.data,
    required this.size,
    required this.visible,
    required this.locked,
    required this.selected,
    required this.position,
    required this.scale,
    required this.rotation,
    this.textStyle,
  });

  final String id;
  final LayerType type;
  final String name;
  final String data;
  final Size size;
  final bool visible;
  final bool locked;
  final bool selected;
  final Offset position;
  final double scale;
  final double rotation;
  final TextStyleModel? textStyle;

  factory DesignLayerModel.fromJson(Map<String, dynamic> json) {
    final typeName = json['type']?.toString();
    final size = _map(json['size']);
    final position = _map(json['position']);

    return DesignLayerModel(
      id: json['id']?.toString() ?? DateTime.now().toString(),
      type: LayerType.values.firstWhere(
        (type) => type.name == typeName,
        orElse: () => LayerType.text,
      ),
      name: json['name']?.toString() ?? 'Layer',
      data: json['data']?.toString() ?? '',
      size: Size(_double(size['width'], 100), _double(size['height'], 100)),
      visible: json['visible'] != false,
      locked: json['locked'] == true,
      selected: false,
      position: Offset(_double(position['dx'], 100), _double(position['dy'], 100)),
      scale: _double(json['scale'], 1),
      rotation: _double(json['rotation'], 0),
      textStyle: json['text_style'] is Map<String, dynamic>
          ? TextStyleModel.fromJson(_map(json['text_style']))
          : null,
    );
  }

  DesignLayerModel copyWith({
    String? id,
    LayerType? type,
    String? name,
    String? data,
    Size? size,
    bool? visible,
    bool? locked,
    bool? selected,
    Offset? position,
    double? scale,
    double? rotation,
    TextStyleModel? textStyle,
  }) {
    return DesignLayerModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      data: data ?? this.data,
      size: size ?? this.size,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      selected: selected ?? this.selected,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'data': data,
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'visible': visible,
      'locked': locked,
      'selected': selected,
      'position': {
        'dx': position.dx,
        'dy': position.dy,
      },
      'scale': scale,
      'rotation': rotation,
      if (textStyle != null) 'text_style': textStyle!.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignLayerModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          name == other.name &&
          data == other.data &&
          size == other.size &&
          visible == other.visible &&
          locked == other.locked &&
          selected == other.selected &&
          position == other.position &&
          scale == other.scale &&
          rotation == other.rotation &&
          textStyle == other.textStyle;

  @override
  int get hashCode => Object.hash(
    id,
    type,
    name,
    data,
    size,
    visible,
    locked,
    selected,
    position,
    scale,
    rotation,
    textStyle,
  );

  @override
  String toString() =>
      'DesignLayerModel(id: $id, type: $type, name: $name, pos: $position)';
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

double _double(Object? value, double fallback) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}
