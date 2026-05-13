import 'package:flutter/material.dart';

class TemplateModel {
  final String id;
  final String title;
  final IconData icon;
  final bool selected;

  const TemplateModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.selected,
  });

  TemplateModel copyWith({
    String? id,
    String? title,
    IconData? icon,
    bool? selected,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      selected: selected ?? this.selected,
    );
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
