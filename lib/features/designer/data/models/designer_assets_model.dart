import 'design_sticker_model.dart';
import 'saved_design_model.dart';
import 'template_model.dart';

class DesignerAssetsModel {
  const DesignerAssetsModel({
    required this.templates,
    required this.stickers,
    this.savedDesigns = const [],
  });

  final List<TemplateModel> templates;
  final List<DesignStickerModel> stickers;
  final List<SavedDesignModel> savedDesigns;
}
