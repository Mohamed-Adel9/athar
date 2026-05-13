import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../data/models/ai_prompt_model.dart';
import '../../data/models/product_type_model.dart';
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
    final products = [
      const ProductTypeModel(
        title: 'تيشرت',
        mockUpImage: "assets/images/design/t-shirt.png",
      ),
      const ProductTypeModel(
        title: 'هودي',
        mockUpImage: "assets/images/design/hoodie.png",
      ),
      const ProductTypeModel(
        title: 'مج',
        mockUpImage: "assets/images/design/mug.png",
      ),
      const ProductTypeModel(
        title: 'توتي باج',
        mockUpImage: "assets/images/design/tote-bag.png",
      ),
      const ProductTypeModel(
        title: 'جراب',
        mockUpImage: "assets/images/design/case.png",
      ),
    ];

    final prompts = [
      const AiPromptModel(title: 'Cyberpunk lion'),
      const AiPromptModel(title: 'Arabic calligraphy'),
      const AiPromptModel(title: 'Minimal streetwear'),
      const AiPromptModel(title: 'Luxury typography'),
      const AiPromptModel(title: 'Neon Japanese art'),
    ];

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.glassGradient),
      child: SafeArea(
        child: BlocBuilder<DesignerCubit, DesignerState>(
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
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
                          itemBuilder: (_, index) {
                            return ProductSelectorCard(
                              model: products[index],
                              selected:
                                  state.selectedProduct.title ==
                                  products[index].title,
                              onTap: () {
                                context.read<DesignerCubit>().selectProduct(
                                  products[index],
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: AppSpacing.sm),
                          itemCount: products.length,
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
                            onTap: () {
                              context.read<DesignerCubit>().addImageLayer();
                            },
                          ),

                          UploadActionCard(
                            icon: Icons.text_fields_rounded,
                            title: 'اضف نص',
                            onTap: () {
                              context.read<DesignerCubit>().addTextLayer();
                            },
                          ),

                          UploadActionCard(
                            icon: Icons.emoji_emotions_rounded,
                            title: 'اضف ملصق',
                            onTap: () {
                              context.read<DesignerCubit>().addStickerLayer();
                            },
                          ),
                        ]),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.4,
                            ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 15)),
                  ],
                ),

                Positioned(
                  right: 16,
                  top: 150,
                  child: BlocBuilder<DesignerCubit, DesignerState>(
                    builder: (context, state) {
                      final isOpen = state.showLayersPanel;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: isOpen ? 260 : 48,
                        height: isOpen ? 360 : 48,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.darkSurface.withValues(
                                alpha: .55,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColors.darkBorder),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: isOpen
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        child: InkWell(
                                          onTap: () => context
                                              .read<DesignerCubit>()
                                              .toggleLayersPanel(),
                                          child: const Center(
                                            child: Icon(
                                              Icons.layers_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Expanded(child: LayersPanel()),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () => context
                                        .read<DesignerCubit>()
                                        .toggleLayersPanel(),
                                    child: const Center(
                                      child: Icon(
                                        Icons.layers_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: DesignerBottomBar(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
