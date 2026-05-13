// ============================================
// FILE: features/designer/data/models/design_layer_model.dart
// ============================================

import 'package:flutter/material.dart';

import 'text_style_model.dart';

enum LayerType { image, text, sticker }

class DesignLayerModel {
  final String id;
  final LayerType type;
  final String name;
  final String data;
  final bool visible;
  final bool locked;
  final bool selected;
  final Offset position;
  final double scale;
  final double rotation;
  final TextStyleModel? textStyle;

  const DesignLayerModel({
    required this.id,
    required this.type,
    required this.name,
    required this.data,
    required this.visible,
    required this.locked,
    required this.selected,
    required this.position,
    required this.scale,
    required this.rotation,
    this.textStyle,
  });

  DesignLayerModel copyWith({
    String? id,
    LayerType? type,
    String? name,
    String? data,
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
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      selected: selected ?? this.selected,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
