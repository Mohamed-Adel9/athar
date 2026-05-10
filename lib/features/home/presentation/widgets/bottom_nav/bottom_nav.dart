import 'package:athar/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_spacing.dart';
import 'bottom_nav_item.dart';
import 'bottom_nav_tab.dart';

class BottomNav extends StatelessWidget {
  final BottomNavTab activeTab;
  final ValueChanged<BottomNavTab> onNavigate;

  const BottomNav({
    super.key,
    required this.activeTab,
    required this.onNavigate,
  });

  static const List<NavItem> _tabs = [
    NavItem(
      tab: BottomNavTab.home,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'الرئيسيه',
    ),
    NavItem(
      tab: BottomNavTab.wishlist,
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'المفضله',
    ),
    NavItem(
      tab: BottomNavTab.designer,
      icon: Icons.brush_outlined,
      activeIcon: Icons.brush,
      label: 'التصاميم',
    ),
    NavItem(
      tab: BottomNavTab.cart,
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'السلة',
    ),
    NavItem(
      tab: BottomNavTab.profile,
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'حسابي',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface.withValues(alpha: 0.70),
        border: Border(top: BorderSide(color: AppColors.darkBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _tabs.map((tab) {
            return BottomNavItem(
              item: tab,
              isActive: activeTab == tab.tab,
              onTap: () => onNavigate(tab.tab),
            );
          }).toList(),
        ),
      ),
    );
  }
}
