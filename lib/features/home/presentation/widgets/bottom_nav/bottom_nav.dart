import 'package:athar/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/app_localizations.dart';
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
      label: 'الرئيسية',
    ),
    NavItem(
      tab: BottomNavTab.shop,
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
      label: 'المنتجات',
    ),
    NavItem(
      tab: BottomNavTab.designer,
      icon: Icons.brush_outlined,
      activeIcon: Icons.brush,
      label: 'التصميم',
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
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context).withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: AppColors.border(context))),
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
              label: _labelFor(l10n, tab.tab),
              isActive: activeTab == tab.tab,
              onTap: () => onNavigate(tab.tab),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _labelFor(AppLocalizations l10n, BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.home:
        return l10n.home;
      case BottomNavTab.shop:
        return l10n.shop;
      case BottomNavTab.designer:
        return l10n.designer;
      case BottomNavTab.cart:
        return l10n.cart;
      case BottomNavTab.profile:
        return l10n.profile;
    }
  }
}
