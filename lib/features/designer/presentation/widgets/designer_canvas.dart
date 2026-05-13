import 'package:athar/shared/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../data/models/design_layer_model.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';
import 'grid_painter.dart';

class DesignerCanvas extends StatelessWidget {
  const DesignerCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerCubit, DesignerState>(
      builder: (context, state) {
        return InteractiveViewer(
          minScale: .5,
          maxScale: 2,
          child: Transform.rotate(
            angle: state.rotation,
            child: Transform.scale(
              scale: state.zoom,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.5,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: AppShadows.soft,
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  children: [
                    if (state.showSnapGuides)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: GridPainter(gridSize: 30),
                          ),
                        ),
                      ),

                    Center(
                      child: Image.asset(
                        state.selectedProduct.mockUpImage,
                        fit: BoxFit.contain,
                      ),
                    ),

                    ...state.layers
                        .where((e) => e.visible)
                        .map((layer) => _LayerWidget(layer: layer)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LayerWidget extends StatelessWidget {
  const _LayerWidget({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: GestureDetector(
        onTap: () {
          context.read<DesignerCubit>().selectLayer(layer.id);
        },
        onPanUpdate: (details) {
          context.read<DesignerCubit>().moveLayer(layer.id, details.delta);
        },
        child: Transform.rotate(
          angle: layer.rotation,
          child: Transform.scale(
            scale: layer.scale,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: layer.selected
                      ? AppColors.neonBlue
                      : Colors.transparent,
                ),
              ),
              child: layer.type == LayerType.text
                  ? Text(
                      layer.data,
                      style: TextStyle(
                        fontSize: layer.textStyle?.fontSize,
                        fontWeight: layer.textStyle?.isBold == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontStyle: layer.textStyle?.isItalic == true
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: layer.textStyle?.color,
                      ),
                    )
                  : Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
