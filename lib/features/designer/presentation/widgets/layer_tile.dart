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
          _VisibilityButton(layer: layer),
          _LockButton(layer: layer),
          Expanded(
            child: Text(
              layer.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: layer.visible ? Colors.white : Colors.white38,
                decoration: layer.locked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          _DeleteButton(layerId: layer.id),
        ],
      ),
    );
  }
}

class _VisibilityButton extends StatelessWidget {
  const _VisibilityButton({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    return _IconButton(
      icon: layer.visible ? Icons.visibility : Icons.visibility_off,
      onTap: () =>
          context.read<DesignerCubit>().toggleLayerVisibility(layer.id),
    );
  }
}

class _LockButton extends StatelessWidget {
  const _LockButton({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    return _IconButton(
      icon: layer.locked ? Icons.lock : Icons.lock_open,
      onTap: () => context.read<DesignerCubit>().lockLayer(layer.id),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.layerId});

  final String layerId;

  @override
  Widget build(BuildContext context) {
    return _IconButton(
      icon: Icons.delete_rounded,
      color: Colors.red,
      onTap: () => context.read<DesignerCubit>().removeLayer(layerId),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        onPressed: onTap,
        icon: Icon(icon, color: color ?? Colors.white),
      ),
    );
  }
}
