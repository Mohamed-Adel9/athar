import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../data/models/design_layer_model.dart';
import '../cubit/designer_cubit.dart';

class TextToolbar extends StatelessWidget {
  final DesignLayerModel layer;

  const TextToolbar({super.key, required this.layer});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.darkSurface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.format_bold,
                color: (layer.textStyle?.isBold ?? false)
                    ? AppColors.neonBlue
                    : Colors.white,
              ),
              onPressed: () => cubit.updateTextLayer(
                id: layer.id,
                bold: !(layer.textStyle?.isBold ?? false),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.format_italic,
                color: (layer.textStyle?.isItalic ?? false)
                    ? AppColors.neonBlue
                    : Colors.white,
              ),
              onPressed: () => cubit.updateTextLayer(
                id: layer.id,
                italic: !(layer.textStyle?.isItalic ?? false),
              ),
            ),

            IconButton(
              icon: Icon(
                Icons.color_lens,
                color: layer.textStyle?.color ?? Colors.white,
              ),
              onPressed: () => _showColorPicker(context, layer.id, cubit),
            ),
          ],
        ),
      ),
    );
  }
}

void _showColorPicker(
  BuildContext context,
  String layerId,
  DesignerCubit cubit,
) {
  final colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    AppColors.darkBackground,
    AppColors.neonBlue,
    AppColors.neonPurple,
    AppColors.neonOrange,
  ];

  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 220,
        color: AppColors.darkSurface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText('اختر لون', variant: TextVariant.labelMedium),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: colors.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      cubit.updateTextLayer(id: layerId, color: colors[index]);
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: colors[index],
                      child: colors[index] == Colors.white
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 16,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
