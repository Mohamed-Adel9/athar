import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../data/models/saved_design_model.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';

class SavedDesignsDialog extends StatelessWidget {
  const SavedDesignsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkSurface,
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
                    icon: const Icon(Icons.refresh, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.darkBorder),
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
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: _PreviewImage(path: design.previewImage),
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
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: 12,
                      ),
                    ),
                  if (design.templateName != null)
                    Text(
                      design.templateName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final value = path;
    if (value == null || value.isEmpty) {
      return Container(
        color: Colors.white.withValues(alpha: 0.08),
        child: const Icon(Icons.image_outlined, color: Colors.white54),
      );
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Image.network(value, fit: BoxFit.cover);
    }

    return Image.asset(value, fit: BoxFit.cover);
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
            Icon(icon, color: Colors.white54, size: 36),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
