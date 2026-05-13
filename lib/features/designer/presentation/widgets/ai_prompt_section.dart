// ============================================
// FILE: features/designer/presentation/views/widgets/ai_prompt_section.dart
// ============================================

import 'package:athar/features/designer/presentation/widgets/prompt_chip.dart';
import 'package:flutter/material.dart';

import '../../../../shared/theme/app_color.dart';
import '../../data/models/ai_prompt_model.dart';

class AiPromptSection extends StatelessWidget {
  const AiPromptSection({super.key, required this.prompts});

  final List<AiPromptModel> prompts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white.withOpacity(.04),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Design Generator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Describe your premium design...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(.4)),
                filled: true,
                fillColor: Colors.white.withOpacity(.03),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.darkBorder),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: prompts.map((e) => PromptChip(title: e.title)).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: AppColors.primaryGradient,
              ),
              child: const Text(
                'Generate AI Design',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
