import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_shadows.dart';
import '../cubit/designer_cubit.dart';

class CanvasToolbar extends StatelessWidget {
  const CanvasToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    final items = [
      _ToolbarItem(icon: Icons.zoom_in_rounded, onTap: cubit.zoomIn),
      _ToolbarItem(icon: Icons.zoom_out_rounded, onTap: cubit.zoomOut),
      _ToolbarItem(icon: Icons.rotate_right_rounded, onTap: cubit.rotateCanvas),
      _ToolbarItem(icon: Icons.flip_rounded, onTap: cubit.resetCanvas),
      _ToolbarItem(icon: Icons.grid_4x4_rounded, onTap: cubit.toggleGrid),
    ];

    return SizedBox(
      height: 55,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) => _ToolbarButton(item: items[index]),
      ),
    );
  }
}

class _ToolbarItem {
  const _ToolbarItem({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.item});

  final _ToolbarItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: item.onTap,
      child: Container(
        width: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface(context).withValues(alpha: .86),
          boxShadow: AppShadows.soft,
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Icon(item.icon, color: AppColors.textPrimary(context)),
      ),
    );
  }
}
