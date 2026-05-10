import 'package:flutter/material.dart';

class SettingItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingItem({required this.icon, required this.title, required this.onTap});
}
