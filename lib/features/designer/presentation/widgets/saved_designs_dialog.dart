import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/app_image.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../data/models/design_layer_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/saved_design_model.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';

class SavedDesignsDialog extends StatelessWidget {
  const SavedDesignsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: CustomText(
                      'التصاميم المحفوظة',
                      variant: TextVariant.bodyLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        context.read<DesignerCubit>().fetchSavedDesigns(),
                    icon: Icon(
                      Icons.refresh,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.border(context)),
            Expanded(
              child: BlocBuilder<DesignerCubit, DesignerState>(
                buildWhen: (previous, current) =>
                    previous.savedDesigns != current.savedDesigns ||
                    previous.isLoadingSavedDesigns !=
                        current.isLoadingSavedDesigns ||
                    previous.savedDesignsError != current.savedDesignsError,
                builder: (context, state) {
                  if (state.isLoadingSavedDesigns) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.savedDesignsError != null) {
                    return _Message(
                      icon: Icons.error_outline,
                      text: state.savedDesignsError!,
                    );
                  }

                  if (state.savedDesigns.isEmpty) {
                    return const _Message(
                      icon: Icons.bookmark_border,
                      text: 'لا توجد تصاميم محفوظة حتى الآن',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: state.savedDesigns.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final design = state.savedDesigns[index];
                      return _SavedDesignTile(design: design);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedDesignTile extends StatelessWidget {
  const _SavedDesignTile({required this.design});

  final SavedDesignModel design;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        context.read<DesignerCubit>().openSavedDesign(design);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: _SavedDesignPreview(design: design),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(design.name, variant: TextVariant.labelMedium),
                  const SizedBox(height: 6),
                  if (design.productName != null)
                    Text(
                      design.productName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  if (design.templateName != null)
                    Text(
                      design.templateName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary(
                          context,
                        ).withValues(alpha: 0.82),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_left, color: AppColors.textSecondary(context)),
          ],
        ),
      ),
    );
  }
}

class _SavedDesignPreview extends StatelessWidget {
  const _SavedDesignPreview({required this.design});

  static const double _previewSize = 72;
  static const double _canvasSize = 360;

  final SavedDesignModel design;

  @override
  Widget build(BuildContext context) {
    final previewImage = design.previewImage?.trim();
    if (previewImage != null && previewImage.isNotEmpty) {
      return AppImage(
        source: previewImage,
        width: _previewSize,
        height: _previewSize,
        fit: BoxFit.cover,
      );
    }

    final product = _productFromDesignData(design.designData);
    if (product == null || product.mockUpImage.trim().isEmpty) {
      return const AppImage(
        source: null,
        width: _previewSize,
        height: _previewSize,
        fit: BoxFit.cover,
      );
    }

    final layers = _layersFromDesignData(design.designData);

    return ColoredBox(
      color: AppColors.surfaceVariant(context),
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _canvasSize,
          height: _canvasSize,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: AppImage(
                    source: product.mockUpImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              for (final layer in layers.where((layer) => layer.visible))
                _PreviewLayer(layer: layer),
            ],
          ),
        ),
      ),
    );
  }

  ProductTypeModel? _productFromDesignData(Map<String, dynamic> data) {
    final product = data['product'];
    if (product is! Map<String, dynamic>) return null;
    return ProductTypeModel.fromJson(product);
  }

  List<DesignLayerModel> _layersFromDesignData(Map<String, dynamic> data) {
    final rawLayers = data['layers'];
    if (rawLayers is! List) return const [];

    return rawLayers
        .whereType<Map<String, dynamic>>()
        .map(DesignLayerModel.fromJson)
        .toList();
  }
}

class _PreviewLayer extends StatelessWidget {
  const _PreviewLayer({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: Transform.rotate(
        angle: layer.rotation,
        child: _PreviewLayerContent(layer: layer),
      ),
    );
  }
}

class _PreviewLayerContent extends StatelessWidget {
  const _PreviewLayerContent({required this.layer});

  final DesignLayerModel layer;

  @override
  Widget build(BuildContext context) {
    switch (layer.type) {
      case LayerType.text:
        return Transform.scale(
          scale: layer.scale,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: layer.size.width,
            height: layer.size.height,
            child: Text(
              layer.data,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
      case LayerType.sticker:
        return SizedBox(
          width: layer.size.width,
          height: layer.size.height,
          child: Transform.scale(
            scale: layer.scale,
            alignment: Alignment.topLeft,
            child: AppImage(
              source: layer.data,
              fit: layer.type == LayerType.image
                  ? BoxFit.cover
                  : BoxFit.contain,
            ),
          ),
        );
    }
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary(context), size: 36),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
