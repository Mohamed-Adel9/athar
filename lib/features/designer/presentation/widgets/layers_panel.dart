import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';
import 'layer_tile.dart';

class LayersPanel extends StatelessWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerCubit, DesignerState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neonBlue.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${state.layers.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('الطبقات', style: TextStyle(color: Colors.white)),
                ],
              ),

              const SizedBox(height: 12),

              Expanded(
                child: state.layers.isEmpty
                    ? const Center(
                        child: Text(
                          'لا يوجد طبقات حاليا',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.layers.length,
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) newIndex -= 1;

                          context.read<DesignerCubit>().reorderLayers(
                            oldIndex,
                            newIndex,
                          );
                        },
                        itemBuilder: (_, index) {
                          final layer = state.layers[index];

                          return Padding(
                            key: ValueKey(layer.id),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ReorderableDragStartListener(
                              index: index,
                              child: LayerTile(layer: layer),
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
}
