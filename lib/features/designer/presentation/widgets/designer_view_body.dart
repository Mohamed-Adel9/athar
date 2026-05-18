import 'package:athar/features/designer/presentation/widgets/sticker_picker_sheet.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';
import 'canvas_toolbar.dart';
import 'designer_bottom_bar.dart';
import 'designer_canvas.dart';
import 'designer_header.dart';
import 'layers_panel.dart';
import 'product_selector_card.dart';
import 'upload_action_card.dart';

class DesignerViewBody extends StatelessWidget {
  const DesignerViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.glassGradient),
      child: SafeArea(
        child: Stack(
          children: [
            const _MainScrollContent(),
            const _LayersPanelToggle(),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: DesignerBottomBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainScrollContent extends StatelessWidget {
  const _MainScrollContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerCubit, DesignerState>(
      buildWhen: (previous, current) =>
          previous.products != current.products ||
          previous.selectedProduct != current.selectedProduct ||
          previous.layers != current.layers ||
          previous.showSnapGuides != current.showSnapGuides ||
          previous.zoom != current.zoom ||
          previous.rotation != current.rotation,
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: DesignerHeader()),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.23,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 7,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.products.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (_, index) {
                    final product = state.products[index];
                    return ProductSelectorCard(
                      model: product,
                      selected: state.selectedProduct == product,
                      onTap: () =>
                          context.read<DesignerCubit>().selectProduct(product),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
            const SliverToBoxAdapter(child: DesignerCanvas()),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
            const SliverToBoxAdapter(child: CanvasToolbar()),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate.fixed([
                  UploadActionCard(
                    icon: Icons.upload_rounded,
                    title: 'ارفع صورة',
                    onTap: () => context.read<DesignerCubit>().addImageLayer(),
                  ),
                  UploadActionCard(
                    icon: Icons.text_fields_rounded,
                    title: 'اضف نص',
                    onTap: () => context.read<DesignerCubit>().addTextLayer(),
                  ),
                  UploadActionCard(
                    icon: Icons.emoji_emotions_rounded,
                    title: 'اضف ملصق',
                    onTap: () => _showStickerPicker(context),
                  ),
                ]),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
          ],
        );
      },
    );
  }

  void _showStickerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<DesignerCubit>(),
        child: const StickerPickerSheet(),
      ),
    );
  }
}

class _LayersPanelToggle extends StatelessWidget {
  const _LayersPanelToggle();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 150,
      child: BlocSelector<DesignerCubit, DesignerState, bool>(
        selector: (state) => state.showLayersPanel,
        builder: (context, showLayersPanel) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: showLayersPanel
                ? const _ExpandedLayersPanel(key: ValueKey('expanded'))
                : _CollapsedLayersButton(
                    key: const ValueKey('collapsed'),
                    onTap: () =>
                        context.read<DesignerCubit>().toggleLayersPanel(),
                  ),
          );
        },
      ),
    );
  }
}

class _CollapsedLayersButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CollapsedLayersButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.darkSurface.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: const Icon(
            Icons.layers_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _ExpandedLayersPanel extends StatelessWidget {
  const _ExpandedLayersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 260,
        height: 360,
        decoration: BoxDecoration(
          color: AppColors.darkSurface.withValues(alpha: .55),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: InkWell(
                onTap: () => context.read<DesignerCubit>().toggleLayersPanel(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.layers_rounded, color: Colors.white),
                    CustomText("اضغط للاغلاق", variant: TextVariant.bodySmall),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            const Expanded(child: LayersPanel()),
          ],
        ),
      ),
    );
  }
}
