import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String value;

  const StatItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CustomText(value, variant: TextVariant.headingMedium),
          const SizedBox(height: 4),
          CustomText(label, variant: TextVariant.bodySmall),
        ],
      ),
    );
  }
}
