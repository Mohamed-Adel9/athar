import 'dart:io';
import 'dart:math' as math; // <-- ADD THIS

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_shadows.dart';
import '../../data/models/design_layer_model.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';
import 'grid_painter.dart';
import 'text_tool_bar.dart';

class DesignerCanvas extends StatelessWidget {
  const DesignerCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerCubit, DesignerState>(
      builder: (context, state) {
        final cubit = context.read<DesignerCubit>();

        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 2.0,
          child: Transform.rotate(
            angle: state.rotation,
            child: Transform.scale(
              scale: state.zoom,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.5,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: AppShadows.soft,
                  border: Border.all(color: AppColors.border(context)),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  children: [
                    if (state.showSnapGuides)
                      const Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: GridPainter(gridSize: 30),
                          ),
                        ),
                      ),

                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => cubit.unselectAll(),
                      child: Center(
                        child: Image.asset(
                          state.selectedProduct!.mockUpImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    for (final layer in state.layers.where((e) => e.visible))
                      _LayerWidget(key: ValueKey(layer.id), layer: layer),

                    const _FloatingTextToolbar(),
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

class _FloatingTextToolbar extends StatelessWidget {
  const _FloatingTextToolbar();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DesignerCubit, DesignerState, DesignLayerModel?>(
      selector: (state) {
        final selected = state.selectedLayer;
        if (selected?.type == LayerType.text) return selected;
        return null;
      },
      builder: (context, textLayer) {
        if (textLayer == null) return const SizedBox.shrink();

        return Positioned(
          left: textLayer.position.dx,
          top: textLayer.position.dy - 60,
          child: TextToolbar(layer: textLayer),
        );
      },
    );
  }
}

class _LayerWidget extends StatelessWidget {
  const _LayerWidget({super.key, required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: Transform.rotate(
        angle: layer.rotation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ---- CONTENT + MOVEMENT ----
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                cubit.selectLayer(layer.id);
                if (layer.type == LayerType.text) {
                  _showTextEditor(context, layer);
                }
              },
              onPanUpdate: (details) {
                if (layer.locked) return;

                // FIX #2: Convert local delta back to parent coordinates
                // because the widget is inside Transform.rotate
                final cos = math.cos(layer.rotation);
                final sin = math.sin(layer.rotation);
                final parentDx =
                    details.delta.dx * cos - details.delta.dy * sin;
                final parentDy =
                    details.delta.dx * sin + details.delta.dy * cos;

                cubit.moveLayer(layer.id, Offset(parentDx, parentDy));
              },
              child: _LayerContent(layer: layer),
            ),

            // ---- RESIZE HANDLE (sibling) ----
            if (layer.selected && !layer.locked) _ResizeHandle(layer: layer),

            // ---- ROTATE HANDLE (sibling) ----
            if (layer.selected && !layer.locked) _RotateHandle(layer: layer),
          ],
        ),
      ),
    );
  }
}

class _LayerContent extends StatelessWidget {
  const _LayerContent({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    switch (layer.type) {
      case LayerType.text:
        return Transform.scale(
          scale: layer.scale,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: layer.selected ? AppColors.neonBlue : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              layer.data,
              style: TextStyle(
                fontFamily: layer.textStyle?.fontFamily,
                fontSize: layer.textStyle?.fontSize,
                fontWeight: layer.textStyle?.isBold == true
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontStyle: layer.textStyle?.isItalic == true
                    ? FontStyle.italic
                    : FontStyle.normal,
                color: layer.textStyle?.color,
                letterSpacing: layer.textStyle?.letterSpacing,
                height: layer.textStyle?.lineHeight,
              ),
            ),
          ),
        );

      case LayerType.image:
        return Container(
          width: layer.size.width,
          height: layer.size.height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: layer.selected ? AppColors.neonBlue : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: _CanvasImage(path: layer.data, fit: BoxFit.cover),
        );

      case LayerType.sticker:
        return Container(
          width: layer.size.width,
          height: layer.size.height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: layer.selected ? AppColors.neonBlue : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: _StickerLayerImage(path: layer.data),
        );
    }
  }
}

class _CanvasImage extends StatelessWidget {
  const _CanvasImage({required this.path, required this.fit});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (_, _, _) => _buildError(),
      );
    }

    return Image.file(
      File(path),
      fit: fit,
      errorBuilder: (_, _, _) => _buildError(),
    );
  }

  Widget _buildError() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.red),
    );
  }
}

class _StickerLayerImage extends StatelessWidget {
  const _StickerLayerImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildError(),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _buildError(),
    );
  }

  Widget _buildError() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.red),
    );
  }
}

class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Positioned(
      right: -28,
      bottom: -28,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) {},
        onPanUpdate: (details) {
          if (layer.type == LayerType.text) {
            cubit.resizeLayer(layer.id, details.delta.dx * 0.01);
          } else {
            cubit.resizeLayerSize(layer.id, details.delta.dx, details.delta.dy);
          }
        },
        child: SizedBox(
          width: 72,
          height: 72,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neonBlue, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonBlue.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.open_in_full,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RotateHandle extends StatelessWidget {
  const _RotateHandle({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Positioned(
      top: -32,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            cubit.rotateLayer(layer.id, details.delta.dx * 0.05);
          },
          child: SizedBox(
            width: 54,
            height: 64,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.neonBlue, width: 2),
                  ),
                  child: const Icon(
                    Icons.rotate_right,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
                Container(width: 2, height: 24, color: AppColors.neonBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showTextEditor(BuildContext context, DesignLayerModel layer) {
  final cubit = context.read<DesignerCubit>();
  final controller = TextEditingController(text: layer.data);
  final focusNode = FocusNode();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary(context).withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              focusNode: focusNode,
              style: TextStyle(color: AppColors.textPrimary(sheetContext)),
              decoration: InputDecoration(
                hintText: 'اكتب النص...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary(sheetContext),
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  cubit.updateTextLayer(id: layer.id, text: value),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'الحجم',
                    style: TextStyle(
                      color: AppColors.textPrimary(sheetContext),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Slider(
                    min: 10,
                    max: 120,
                    value: layer.textStyle?.fontSize ?? 20,
                    onChanged: (value) =>
                        cubit.updateTextLayer(id: layer.id, fontSize: value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    color: (layer.textStyle?.isBold ?? false)
                        ? AppColors.neonBlue
                        : AppColors.textPrimary(sheetContext),
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
                        : AppColors.textPrimary(sheetContext),
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
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );

  focusNode.requestFocus();
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
  ];

  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 220,
        color: AppColors.surface(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر اللون',
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 18,
              ),
            ),
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
