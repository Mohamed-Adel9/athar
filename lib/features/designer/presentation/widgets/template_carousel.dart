import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/theme/app_color.dart';

class TemplateCarousel extends StatelessWidget {
  const TemplateCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final templates = [
      'Streetwear',
      'Arabic Luxury',
      'Neon Gaming',
      'Anime',
      'Minimal',
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return Container(
            width: 150,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: AppColors.glassGradient,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                templates[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ).animate().fade().slideX(begin: .2);
        },
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: templates.length,
      ),
    );
  }
}
