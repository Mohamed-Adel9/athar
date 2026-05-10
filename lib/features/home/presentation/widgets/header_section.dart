import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final Function(String) onNavigate;

  const HeaderSection({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return CustomText("مرحبا , أحمد", variant: TextVariant.bodyLarge);
  }
}
