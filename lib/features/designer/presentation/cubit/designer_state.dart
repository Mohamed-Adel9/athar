import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/models/design_layer_model.dart';
import '../../data/models/design_sticker_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/saved_design_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/text_style_model.dart';

enum DesignerTool { none, text, image, sticker }

class DesignerState {
  //  Design Data
  final List<ProductTypeModel> products;
  final ProductTypeModel? selectedProduct;
  final List<DesignLayerModel> layers;
  final DesignLayerModel? selectedLayer;
  final List<TemplateModel> templates;
  final TemplateModel? selectedTemplate;
  final List<DesignStickerModel> stickers;
  final List<SavedDesignModel> savedDesigns;
  final double zoom;
  final double rotation;
  final TextStyleModel activeTextStyle;

  //  UI Chrome
  final bool isSaving;
  final bool isLoadingSavedDesigns;
  final String? savedDesignsError;
  final bool previewMode;
  final bool showSnapGuides;
  final bool showToolbar;
  final bool showLayersPanel;
  final DesignerTool selectedTool;

  const DesignerState({
    required this.products,
    this.selectedProduct,
    required this.layers,
    this.selectedLayer,
    required this.templates,
    this.selectedTemplate,
    required this.stickers,
    required this.savedDesigns,
    this.zoom = 1.0,
    this.rotation = 0.0,
    this.activeTextStyle = TextStyleModel.initial,
    this.isSaving = false,
    this.isLoadingSavedDesigns = false,
    this.savedDesignsError,
    this.previewMode = false,
    this.showSnapGuides = true,
    this.showToolbar = true,
    this.showLayersPanel = true,
    this.selectedTool = DesignerTool.none,
  });

  factory DesignerState.initial() {
    return const DesignerState(
      products: [
        ProductTypeModel(
          title: 'تيشرت',
          mockUpImage: 'assets/images/design/t-shirt.png',
        ),
        ProductTypeModel(
          title: 'هودي',
          mockUpImage: 'assets/images/design/hoodie.png',
        ),
        ProductTypeModel(
          title: 'مج',
          mockUpImage: 'assets/images/design/mug.png',
        ),
        ProductTypeModel(
          title: 'توتي باج',
          mockUpImage: 'assets/images/design/tote-bag.png',
        ),
      ],
      selectedProduct: ProductTypeModel(
        title: 'تيشرت',
        mockUpImage: 'assets/images/design/t-shirt.png',
      ),
      layers: [],
      templates: [
        TemplateModel(
          id: '1',
          title: 'ستريت وير',
          icon: Icons.bolt_rounded,
          selected: true,
        ),
        TemplateModel(
          id: '2',
          title: 'أنمي',
          icon: Icons.auto_awesome_rounded,
          selected: false,
        ),
      ],
      stickers: [
        DesignStickerModel(
          id: 0,
          name: 'fire',
          imageUrl: 'assets/stickers/fire.png',
        ),
        DesignStickerModel(
          id: 0,
          name: 'galaxy',
          imageUrl: 'assets/stickers/galaxy.png',
        ),
        DesignStickerModel(
          id: 0,
          name: 'heart',
          imageUrl: 'assets/stickers/heart.png',
        ),
        DesignStickerModel(
          id: 0,
          name: 'lightning',
          imageUrl: 'assets/stickers/lightning.png',
        ),
        DesignStickerModel(
          id: 0,
          name: 'moon',
          imageUrl: 'assets/stickers/moon.png',
        ),
        DesignStickerModel(
          id: 0,
          name: 'skull',
          imageUrl: 'assets/stickers/skull.png',
        ),
      ],
      savedDesigns: [],
    );
  }

  DesignerState copyWith({
    List<ProductTypeModel>? products,
    ProductTypeModel? selectedProduct,
    bool clearSelectedProduct = false,
    List<DesignLayerModel>? layers,
    DesignLayerModel? selectedLayer,
    bool clearSelectedLayer = false,
    List<TemplateModel>? templates,
    TemplateModel? selectedTemplate,
    bool clearSelectedTemplate = false,
    List<DesignStickerModel>? stickers,
    List<SavedDesignModel>? savedDesigns,
    double? zoom,
    double? rotation,
    TextStyleModel? activeTextStyle,
    bool? isSaving,
    bool? isLoadingSavedDesigns,
    String? savedDesignsError,
    bool clearSavedDesignsError = false,
    bool? previewMode,
    bool? showSnapGuides,
    bool? showToolbar,
    bool? showLayersPanel,
    DesignerTool? selectedTool,
  }) {
    return DesignerState(
      products: products ?? this.products,
      selectedProduct: clearSelectedProduct
          ? null
          : (selectedProduct ?? this.selectedProduct),
      layers: layers ?? this.layers,
      selectedLayer: clearSelectedLayer
          ? null
          : (selectedLayer ?? this.selectedLayer),
      templates: templates ?? this.templates,
      selectedTemplate: clearSelectedTemplate
          ? null
          : (selectedTemplate ?? this.selectedTemplate),
      stickers: stickers ?? this.stickers,
      savedDesigns: savedDesigns ?? this.savedDesigns,
      zoom: zoom ?? this.zoom,
      rotation: rotation ?? this.rotation,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      isSaving: isSaving ?? this.isSaving,
      isLoadingSavedDesigns: isLoadingSavedDesigns ?? this.isLoadingSavedDesigns,
      savedDesignsError: clearSavedDesignsError
          ? null
          : (savedDesignsError ?? this.savedDesignsError),
      previewMode: previewMode ?? this.previewMode,
      showSnapGuides: showSnapGuides ?? this.showSnapGuides,
      showToolbar: showToolbar ?? this.showToolbar,
      showLayersPanel: showLayersPanel ?? this.showLayersPanel,
      selectedTool: selectedTool ?? this.selectedTool,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignerState &&
          runtimeType == other.runtimeType &&
          listEquals(products, other.products) &&
          selectedProduct == other.selectedProduct &&
          listEquals(layers, other.layers) &&
          selectedLayer == other.selectedLayer &&
          listEquals(templates, other.templates) &&
          selectedTemplate == other.selectedTemplate &&
          listEquals(stickers, other.stickers) &&
          listEquals(savedDesigns, other.savedDesigns) &&
          zoom == other.zoom &&
          rotation == other.rotation &&
          activeTextStyle == other.activeTextStyle &&
          isSaving == other.isSaving &&
          isLoadingSavedDesigns == other.isLoadingSavedDesigns &&
          savedDesignsError == other.savedDesignsError &&
          previewMode == other.previewMode &&
          showSnapGuides == other.showSnapGuides &&
          showToolbar == other.showToolbar &&
          showLayersPanel == other.showLayersPanel &&
          selectedTool == other.selectedTool;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(products),
    selectedProduct,
    Object.hashAll(layers),
    selectedLayer,
    Object.hashAll(templates),
    selectedTemplate,
    Object.hashAll(stickers),
    Object.hashAll(savedDesigns),
    zoom,
    rotation,
    activeTextStyle,
    isSaving,
    isLoadingSavedDesigns,
    savedDesignsError,
    previewMode,
    showSnapGuides,
    showToolbar,
    showLayersPanel,
    selectedTool,
  );

  @override
  String toString() {
    return 'DesignerState(layers: ${layers.length}, '
        'selected: ${selectedLayer?.id}, '
        'product: ${selectedProduct?.title}, '
        'zoom: ${zoom.toStringAsFixed(2)}, '
        'tool: $selectedTool)';
  }
}
