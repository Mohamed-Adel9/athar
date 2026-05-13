import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../data/models/design_layer_model.dart';
import '../cubit/designer_cubit.dart';

class LayerTile extends StatelessWidget {
  const LayerTile({super.key, required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: layer.selected
            ? AppColors.neonBlue.withValues(alpha: .15)
            : AppColors.darkTextPrimary.withValues(alpha: .04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              layer.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),

          _iconBtn(
            icon: layer.visible ? Icons.visibility : Icons.visibility_off,
            onTap: () {
              context.read<DesignerCubit>().toggleLayerVisibility(layer.id);
            },
          ),

          _iconBtn(
            icon: layer.locked ? Icons.lock : Icons.lock_open,
            onTap: () {
              context.read<DesignerCubit>().lockLayer(layer.id);
            },
          ),

          _iconBtn(
            icon: Icons.delete_rounded,
            color: Colors.red,
            onTap: () {
              context.read<DesignerCubit>().removeLayer(layer.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        onPressed: onTap,
        icon: Icon(icon, color: color),
      ),
    );
  }
}
