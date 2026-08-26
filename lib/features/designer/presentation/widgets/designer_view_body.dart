import 'package:athar/features/designer/presentation/widgets/sticker_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../data/models/template_model.dart';
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
  const DesignerViewBody({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.glassGradient),
      child: SafeArea(
        child: Stack(
          children: [
            _MainScrollContent(showBackButton: showBackButton),
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
  const _MainScrollContent({required this.showBackButton});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerCubit, DesignerState>(
      buildWhen: (previous, current) =>
          previous.products != current.products ||
          previous.selectedProduct != current.selectedProduct ||
          previous.templates != current.templates ||
          previous.selectedTemplate != current.selectedTemplate ||
          previous.layers != current.layers ||
          previous.showSnapGuides != current.showSnapGuides ||
          previous.zoom != current.zoom ||
          previous.rotation != current.rotation,
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: DesignerHeader(showBackButton: showBackButton),
            ),
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
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
            const SliverToBoxAdapter(child: _TemplateStrip()),
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
                    title: 'أضف نص',
                    onTap: () => context.read<DesignerCubit>().addTextLayer(),
                  ),
                  UploadActionCard(
                    icon: Icons.emoji_emotions_rounded,
                    title: 'أضف ملصق',
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
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
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

class _TemplateStrip extends StatelessWidget {
  const _TemplateStrip();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      DesignerCubit,
      DesignerState,
      ({List<TemplateModel> templates, TemplateModel? selected})
    >(
      selector: (state) =>
          (templates: state.templates, selected: state.selectedTemplate),
      builder: (context, data) {
        if (data.templates.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 96,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: data.templates.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final template = data.templates[index];
              return _TemplateCard(
                template: template,
                selected: data.selected == template || template.selected,
              );
            },
          ),
        );
      },
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.selected});

  final TemplateModel template;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.read<DesignerCubit>().applyTemplate(template),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 104,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.22)
              : AppColors.surface(context).withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border(context),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _TemplatePreview(template: template),
              ),
            ),
            const SizedBox(height: 5),
            CustomText(
              _templateTitle(template.title),
              variant: TextVariant.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplatePreview extends StatelessWidget {
  const _TemplatePreview({required this.template});

  final TemplateModel template;

  @override
  Widget build(BuildContext context) {
    final imageUrl = template.imageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _IconPreview(icon: template.icon),
      );
    }

    return _IconPreview(icon: template.icon);
  }
}

String _templateTitle(String title) {
  final normalized = title.trim().toLowerCase();
  if (normalized.isEmpty) return 'قالب';
  if (normalized == 'anime') return 'أنمي';
  if (normalized == 'streetwear') return 'ستريت وير';
  return title;
}

class _IconPreview extends StatelessWidget {
  const _IconPreview({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant(context),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textSecondary(context), size: 28),
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
  const _CollapsedLayersButton({super.key, required this.onTap});

  final VoidCallback onTap;

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
            color: AppColors.surface(context).withValues(alpha: .9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Icon(
            Icons.layers_rounded,
            color: AppColors.textPrimary(context),
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
          color: AppColors.surface(context).withValues(alpha: .94),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.border(context)),
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
                    Icon(Icons.layers_rounded, color: AppColors.neonBlue),
                    SizedBox(width: 5),
                    CustomText("اضغط للغلق", variant: TextVariant.titleSmall),
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
