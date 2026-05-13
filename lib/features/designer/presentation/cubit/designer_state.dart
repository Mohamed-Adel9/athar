// ============================================
// FILE: features/designer/presentation/cubit/designer_state.dart
// ============================================

import '../../data/models/design_layer_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/text_style_model.dart';

enum DesignerTool { none, text, image, ai, sticker }

class DesignerState {
  final List<ProductTypeModel> products;
  final ProductTypeModel selectedProduct;
  final bool showLayersPanel;

  final List<DesignLayerModel> layers;
  final DesignLayerModel? selectedLayer;

  final List<TemplateModel> templates;
  final TemplateModel? selectedTemplate;

  final double zoom;
  final double rotation;

  final String aiPrompt;

  final bool isGenerating;
  final bool isSaving;
  final bool previewMode;

  final bool showSnapGuides;
  final bool showToolbar;

  final DesignerTool selectedTool;

  final TextStyleModel activeTextStyle;

  final List<DesignerState> undoStack;
  final List<DesignerState> redoStack;

  const DesignerState({
    required this.products,
    required this.selectedProduct,
    required this.layers,
    required this.selectedLayer,
    required this.templates,
    required this.selectedTemplate,
    required this.zoom,
    required this.rotation,
    required this.aiPrompt,
    required this.isGenerating,
    required this.isSaving,
    required this.previewMode,
    required this.showSnapGuides,
    required this.showToolbar,
    required this.selectedTool,
    required this.activeTextStyle,
    required this.undoStack,
    required this.redoStack,
    required this.showLayersPanel,
  });

  DesignerState copyWith({
    List<ProductTypeModel>? products,
    ProductTypeModel? selectedProduct,
    List<DesignLayerModel>? layers,
    DesignLayerModel? selectedLayer,
    List<TemplateModel>? templates,
    TemplateModel? selectedTemplate,
    bool? showLayersPanel,
    double? zoom,
    double? rotation,
    String? aiPrompt,
    bool? isGenerating,
    bool? isSaving,
    bool? previewMode,
    bool? showSnapGuides,
    bool? showToolbar,
    DesignerTool? selectedTool,
    TextStyleModel? activeTextStyle,
    List<DesignerState>? undoStack,
    List<DesignerState>? redoStack,
  }) {
    return DesignerState(
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      layers: layers ?? this.layers,
      selectedLayer: selectedLayer ?? this.selectedLayer,
      templates: templates ?? this.templates,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      zoom: zoom ?? this.zoom,
      rotation: rotation ?? this.rotation,
      aiPrompt: aiPrompt ?? this.aiPrompt,
      isGenerating: isGenerating ?? this.isGenerating,
      isSaving: isSaving ?? this.isSaving,
      previewMode: previewMode ?? this.previewMode,
      showSnapGuides: showSnapGuides ?? this.showSnapGuides,
      showToolbar: showToolbar ?? this.showToolbar,
      selectedTool: selectedTool ?? this.selectedTool,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
      showLayersPanel: showLayersPanel ?? this.showLayersPanel,
    );
  }
}
