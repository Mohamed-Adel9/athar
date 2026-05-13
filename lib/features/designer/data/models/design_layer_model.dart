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