import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../data/models/design_sticker_model.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';

class StickerPickerSheet extends StatelessWidget {
  const StickerPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.border(context))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary(context).withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const CustomText('اختر ملصق', variant: TextVariant.labelMedium),
          const SizedBox(height: 16),
          Expanded(
            child: BlocSelector<
              DesignerCubit,
              DesignerState,
              List<DesignStickerModel>
            >(
              selector: (state) => state.stickers,
              builder: (context, stickers) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: stickers.length,
                  itemBuilder: (context, index) {
                    final sticker = stickers[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        cubit.addStickerLayer(sticker.imageUrl);
                        Navigator.pop(context);
                      },
                      child: _StickerImage(path: sticker.imageUrl),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StickerImage extends StatelessWidget {
  const _StickerImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(path, fit: BoxFit.contain);
    }

    return Image.asset(path, fit: BoxFit.contain);
  }
}
