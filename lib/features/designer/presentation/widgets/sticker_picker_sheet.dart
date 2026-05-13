import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../cubit/designer_cubit.dart';

class StickerPickerSheet extends StatelessWidget {
  const StickerPickerSheet({super.key});

  static const List<String> _stickers = [
    'assets/stickers/fire.png',
    'assets/stickers/galaxy.png',
    'assets/stickers/heart.png',
    'assets/stickers/lightning.png',
    'assets/stickers/moon.png',
    'assets/stickers/skull.png',
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const CustomText(
            'اختر ملصق',
            variant: TextVariant.labelMedium,

          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: _stickers.length,
              itemBuilder: (context, index) {
                final sticker = _stickers[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    cubit.addStickerLayer(sticker);
                    Navigator.pop(context);
                  },
                  child: Image.asset(sticker, fit: BoxFit.contain),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}