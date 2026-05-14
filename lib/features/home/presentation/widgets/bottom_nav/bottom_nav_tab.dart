import 'package:flutter/material.dart';

enum BottomNavTab { home, shop, designer, cart, profile }

class NavItem {
  final BottomNavTab tab;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.tab,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
