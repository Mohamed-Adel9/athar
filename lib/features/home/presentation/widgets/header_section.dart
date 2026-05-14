import 'package:athar/features/home/presentation/widgets/bottom_nav/bottom_nav_tab.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final Function(BottomNavTab) onNavigate;

  const HeaderSection({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return CustomText("مرحبا , أحمد", variant: TextVariant.bodyLarge);
  }
}
