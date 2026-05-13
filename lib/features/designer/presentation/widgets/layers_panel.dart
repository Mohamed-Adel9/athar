import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          padding: const EdgeInsets.all(10),
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
              // Pass raw indices — Cubit handles the adjustment
              context.read<DesignerCubit>().reorderLayers(oldIndex, newIndex);
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
        );
      },
    );
  }
}