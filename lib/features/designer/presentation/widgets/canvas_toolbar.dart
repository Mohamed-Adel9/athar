import 'package:athar/shared/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/designer_cubit.dart';

class CanvasToolbar extends StatelessWidget {
  const CanvasToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    final items = [
      {"icon": Icons.zoom_in_rounded, "action": cubit.zoomIn},
      {"icon": Icons.zoom_out_rounded, "action": cubit.zoomOut},
      {"icon": Icons.rotate_right_rounded, "action": cubit.rotateCanvas},
      {"icon": Icons.flip_rounded, "action": cubit.resetCanvas},
      {"icon": Icons.grid_4x4_rounded, "action": cubit.toggleGrid},
    ];

    return SizedBox(
      height: 55,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: items[index]["action"] as VoidCallback,
            child: Container(
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkSurface.withValues(alpha: .3),
                boxShadow: AppShadows.soft,
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Icon(
                items[index]["icon"] as IconData,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
