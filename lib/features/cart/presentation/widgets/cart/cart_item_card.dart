import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_image.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../../shared/widgets/glass_card.dart';
import '../../../../designer/data/models/design_layer_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../cubit/cart_cubit.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.isCustomDesign
                ? _CustomDesignPreview(item: item)
                : AppImage(
                    source: item.imageUrl,
                    width: 80,
                    height: 80,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.name,
                  variant: TextVariant.bodyMedium,
                  tone: TextTone.primary,
                ),
                if (item.isCustomDesign) ...[
                  const SizedBox(height: 6),
                  const _CustomDesignChip(),
                ],
                const SizedBox(height: 4),
                CustomText(
                  '\u0627\u0644\u0644\u0648\u0646: ${item.color} | \u0627\u0644\u0645\u0642\u0627\u0633: ${item.size}',
                  variant: TextVariant.labelSmall,
                  tone: TextTone.secondary,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onTap: () => cubit.decrementQuantity(item.id),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: CustomText(
                              '${item.quantity}',
                              variant: TextVariant.bodyMedium,
                              tone: TextTone.primary,
                            ),
                          ),
                          _QuantityButton(
                            icon: Icons.add,
                            onTap: () => cubit.incrementQuantity(item.id),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CustomText(
                      '${item.total.toStringAsFixed(0)} \u062c.\u0645',
                      variant: TextVariant.bodyMedium,
                      tone: TextTone.neonBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => cubit.removeItem(item.id),
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomDesignPreview extends StatelessWidget {
  const _CustomDesignPreview({required this.item});

  static const double _previewSize = 80;
  static const double _designCanvasSize = 360;

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final previewImage = item.previewImageUrl?.trim();
    if (previewImage != null && previewImage.isNotEmpty) {
      return AppImage(
        source: previewImage,
        width: _previewSize,
        height: _previewSize,
      );
    }

    final layers = _layersFromDesignData(item.designData);

    return Container(
      width: _previewSize,
      height: _previewSize,
      color: AppColors.darkSurface,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _designCanvasSize,
          height: _designCanvasSize,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: AppImage(source: item.imageUrl, fit: BoxFit.contain),
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

  List<DesignLayerModel> _layersFromDesignData(Map<String, dynamic>? data) {
    final rawLayers = data?['layers'];
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
        return SizedBox(
          width: layer.size.width,
          height: layer.size.height,
          child: Transform.scale(
            scale: layer.scale,
            alignment: Alignment.topLeft,
            child: _LayerImage(source: layer.data, fit: BoxFit.cover),
          ),
        );
      case LayerType.sticker:
        return SizedBox(
          width: layer.size.width,
          height: layer.size.height,
          child: Transform.scale(
            scale: layer.scale,
            alignment: Alignment.topLeft,
            child: _LayerImage(source: layer.data, fit: BoxFit.contain),
          ),
        );
    }
  }
}

class _LayerImage extends StatelessWidget {
  const _LayerImage({required this.source, required this.fit});

  final String source;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final value = source.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Image.network(value, fit: fit, errorBuilder: _errorBuilder);
    }

    final file = File(value);
    if (file.isAbsolute) {
      return Image.file(file, fit: fit, errorBuilder: _errorBuilder);
    }

    return Image.asset(value, fit: fit, errorBuilder: _errorBuilder);
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stack) {
    return ColoredBox(
      color: AppColors.darkSurface.withValues(alpha: .65),
      child: const Icon(Icons.broken_image_outlined, color: AppColors.error),
    );
  }
}

class _CustomDesignChip extends StatelessWidget {
  const _CustomDesignChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neonBlue.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.neonBlue.withValues(alpha: .35)),
      ),
      child: const CustomText(
        '\u062a\u0635\u0645\u064a\u0645 \u0645\u062e\u0635\u0635',
        variant: TextVariant.labelSmall,
        tone: TextTone.neonBlue,
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.darkTextPrimary, size: 16),
        ),
      ),
    );
  }
}
