import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/image_picker_service.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../data/models/design_layer_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/saved_design_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/text_style_model.dart';
import '../../domain/usecases/fetch_designer_assets_usecase.dart';
import '../../domain/usecases/fetch_saved_designs_usecase.dart';
import '../../domain/usecases/save_design_usecase.dart';
import 'designer_state.dart';

class DesignerCubit extends Cubit<DesignerState> {
  DesignerCubit(
    this._fetchDesignerAssetsUseCase,
    this._fetchSavedDesignsUseCase,
    this._saveDesignUseCase,
  )
    : super(DesignerState.initial()) {
    fetchAssets();
  }

  final FetchDesignerAssetsUseCase _fetchDesignerAssetsUseCase;
  final FetchSavedDesignsUseCase _fetchSavedDesignsUseCase;
  final SaveDesignUseCase _saveDesignUseCase;

  //  History
  static const int _maxHistorySize = 50;
  final List<_DesignSnapshot> _history = [];
  final List<_DesignSnapshot> _redoStack = [];

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  DesignLayerModel? get selectedTextLayer {
    final selected = state.selectedLayer;
    if (selected == null || selected.type != LayerType.text) return null;
    return selected;
  }

  //  Product
  Future<void> fetchAssets() async {
    final result = await _fetchDesignerAssetsUseCase();
    result.fold(
      (_) {},
      (assets) {
        emit(
          state.copyWith(
            templates: assets.templates.isEmpty
                ? state.templates
                : assets.templates,
            stickers: assets.stickers.isEmpty ? state.stickers : assets.stickers,
          ),
        );
      },
    );
  }

  Future<void> fetchSavedDesigns() async {
    emit(
      state.copyWith(
        isLoadingSavedDesigns: true,
        clearSavedDesignsError: true,
      ),
    );
    final result = await _fetchSavedDesignsUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingSavedDesigns: false,
            savedDesignsError: failure.message,
          ),
        );
      },
      (designs) {
        emit(
          state.copyWith(
            savedDesigns: designs,
            isLoadingSavedDesigns: false,
            clearSavedDesignsError: true,
          ),
        );
      },
    );
  }

  void selectProduct(ProductTypeModel product) {
    if (state.selectedProduct == product) return;
    _saveHistory();
    emit(state.copyWith(selectedProduct: product));
  }

  //  Canvas

  void zoomIn() => _updateZoom((state.zoom + 0.1).clamp(0.5, 3.0));

  void zoomOut() => _updateZoom((state.zoom - 0.1).clamp(0.5, 3.0));

  void _updateZoom(double newZoom) {
    if ((newZoom - state.zoom).abs() < 0.001) return;
    _saveHistory();
    emit(state.copyWith(zoom: newZoom));
  }

  void rotateCanvas() {
    _saveHistory();
    emit(state.copyWith(rotation: state.rotation + 0.1));
  }

  void resetCanvas() {
    _saveHistory();
    emit(state.copyWith(zoom: 1.0, rotation: 0.0));
  }

  void toggleGrid() {
    emit(state.copyWith(showSnapGuides: !state.showSnapGuides));
  }

  //  UI Panels

  void toggleLayersPanel() {
    emit(state.copyWith(showLayersPanel: !state.showLayersPanel));
  }

  //  Layer CRUD

  void addTextLayer() {
    _saveHistory();

    final layer = DesignLayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.text,
      name: 'طبقة نص',
      data: 'أثر',
      size: const Size(200, 60),
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(120, 160),
      scale: 1.0,
      rotation: 0.0,
      textStyle: state.activeTextStyle,
    );

    final updatedLayers = [
      ...state.layers.map((e) => e.copyWith(selected: false)),
      layer,
    ];

    _emitWithLayers(updatedLayers, selectedLayer: layer);
  }

  void addImageLayer() async {
    final file = await ImagePickerService.pick();
    if (file == null) return;

    _saveHistory();

    final layer = DesignLayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.image,
      name: 'طبقة صورة',
      data: file.path,
      size: const Size(200, 200),
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(100, 100),
      scale: 1.0,
      rotation: 0.0,
    );

    final updatedLayers = [
      ...state.layers.map((e) => e.copyWith(selected: false)),
      layer,
    ];

    _emitWithLayers(updatedLayers, selectedLayer: layer);
  }

  void addStickerLayer(String stickerPath) {
    _saveHistory();
    final layer = DesignLayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.sticker,
      name: 'طبقة ملصق',
      data: stickerPath,
      size: const Size(100, 100),
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(100, 100),
      scale: 1.0,
      rotation: 0.0,
    );
    final updatedLayers = [
      ...state.layers.map((e) => e.copyWith(selected: false)),
      layer,
    ];
    _emitWithLayers(updatedLayers, selectedLayer: layer);
  }

  void removeLayer(String id) {
    if (!state.layers.any((l) => l.id == id)) return;

    _saveHistory();

    final wasSelected = state.selectedLayer?.id == id;
    final updatedLayers = state.layers.where((e) => e.id != id).toList();

    if (wasSelected) {
      // CRITICAL: Use clearSelectedLayer so null actually applies
      emit(
        state.copyWith(
          layers: updatedLayers,
          selectedLayer: null,
          clearSelectedLayer: true,
        ),
      );
    } else {
      _emitWithLayers(updatedLayers);
    }
  }

  void reorderLayers(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= state.layers.length) return;
    if (newIndex < 0 || newIndex > state.layers.length) return;
    if (oldIndex == newIndex) return;

    _saveHistory();

    final updated = List<DesignLayerModel>.from(state.layers);
    final item = updated.removeAt(oldIndex);

    // Flutter's ReorderableListView gives newIndex BEFORE removal
    final effectiveNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    updated.insert(effectiveNewIndex, item);

    _emitWithLayers(updated);
  }

  //  Layer Properties

  void toggleLayerVisibility(String id) {
    final updated = _updateLayerById(
      id,
      (layer) => layer.copyWith(visible: !layer.visible),
    );
    _emitWithLayers(updated);
  }

  void lockLayer(String id) {
    final updated = _updateLayerById(
      id,
      (layer) => layer.copyWith(locked: !layer.locked),
    );
    _emitWithLayers(updated);
  }

  void selectLayer(String id) {
    final target = state.layers.firstWhereOrNull((e) => e.id == id);
    if (target == null) return;

    final updated = state.layers
        .map((e) => e.copyWith(selected: e.id == id))
        .toList();

    emit(
      state.copyWith(
        layers: updated,
        selectedLayer: target.copyWith(selected: true),
      ),
    );
  }

  /// NEW: Unselect everything when tapping empty canvas
  void unselectAll() {
    if (state.selectedLayer == null) return;

    final updated = state.layers
        .map((e) => e.copyWith(selected: false))
        .toList();

    emit(
      state.copyWith(
        layers: updated,
        selectedLayer: null,
        clearSelectedLayer: true,
      ),
    );
  }

  void moveLayer(String id, Offset delta) {
    final updated = _updateLayerById(
      id,
      (layer) => layer.copyWith(position: layer.position + delta),
    );
    _emitWithLayers(updated);
  }

  void updateTextLayer({
    required String id,
    String? text,
    Color? color,
    double? fontSize,
    String? fontFamily,
    bool? bold,
    bool? italic,
  }) {
    _saveHistory();

    final updated = state.layers.map((layer) {
      if (layer.id != id || layer.type != LayerType.text) return layer;

      return layer.copyWith(
        data: text ?? layer.data,
        textStyle: (layer.textStyle ?? TextStyleModel.initial).copyWith(
          fontFamily: fontFamily,
          color: color,
          fontSize: fontSize,
          isBold: bold,
          isItalic: italic,
        ),
      );
    }).toList();

    _emitWithLayers(updated);
  }

  void resizeLayer(String id, double scaleDelta) {
    final updated = _updateLayerById(id, (layer) {
      return layer.copyWith(scale: (layer.scale + scaleDelta).clamp(0.2, 5.0));
    });
    _emitWithLayers(updated);
  }

  void resizeLayerSize(String id, double widthDelta, double heightDelta) {
    _saveHistory();
    final updated = state.layers.map((layer) {
      if (layer.id != id) return layer;
      return layer.copyWith(
        size: Size(
          (layer.size.width + widthDelta).clamp(20.0, 600.0),
          (layer.size.height + heightDelta).clamp(20.0, 600.0),
        ),
      );
    }).toList();
    _emitWithLayers(updated);
  }

  void rotateLayer(String id, double delta) {
    final updated = _updateLayerById(id, (layer) {
      return layer.copyWith(rotation: layer.rotation + delta);
    });
    _emitWithLayers(updated);
  }

  void updateTransform({required String id, double? scale, double? rotation}) {
    final updated = _updateLayerById(id, (layer) {
      return layer.copyWith(
        scale: scale != null ? scale.clamp(0.2, 5.0) : layer.scale,
        rotation: rotation ?? layer.rotation,
      );
    });
    _emitWithLayers(updated);
  }

  //  Templates

  void selectTemplate(TemplateModel template) {
    if (state.selectedTemplate == template) return;
    _saveHistory();
    emit(state.copyWith(selectedTemplate: template));
  }

  void applyTemplate(TemplateModel template) {
    _saveHistory();

    final updatedTemplates = state.templates
        .map((item) => item.copyWith(selected: item.id == template.id))
        .toList();

    final imageUrl = template.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      final layer = _visibleTemplateLayer(template);
      emit(
        state.copyWith(
          templates: updatedTemplates,
          selectedTemplate: template.copyWith(selected: true),
          layers: [
            ...state.layers.map((layer) => layer.copyWith(selected: false)),
            layer,
          ],
          selectedLayer: layer,
        ),
      );
      return;
    }

    final layer = DesignLayerModel(
      id: 'template-${DateTime.now().millisecondsSinceEpoch}',
      type: LayerType.image,
      name: template.title.isEmpty ? 'طبقة قالب' : _templateTitle(template.title),
      data: imageUrl,
      size: const Size(180, 180),
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(110, 140),
      scale: 1.0,
      rotation: 0.0,
    );

    emit(
      state.copyWith(
        templates: updatedTemplates,
        selectedTemplate: template.copyWith(selected: true),
        layers: [
          ...state.layers.map((layer) => layer.copyWith(selected: false)),
          layer,
        ],
        selectedLayer: layer,
      ),
    );
  }

  DesignLayerModel _templateTextLayer(TemplateModel template) {
    final title = _safeTemplateTitle(template.title);
    final normalized = template.title.trim().toLowerCase();
    final isAnime = normalized == 'anime' || title == 'أنمي';
    final isStreetwear = normalized == 'streetwear' || title == 'ستريت وير';

    return DesignLayerModel(
      id: 'template-${DateTime.now().millisecondsSinceEpoch}',
      type: LayerType.text,
      name: title.isEmpty ? 'طبقة قالب' : title,
      data: isAnime
          ? 'أنمي'
          : isStreetwear
          ? 'STREET'
          : title,
      size: const Size(220, 70),
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(105, 150),
      scale: 1.0,
      rotation: isStreetwear ? -0.08 : 0.0,
      textStyle: TextStyleModel.initial.copyWith(
        color: isAnime
            ? const Color(0xFFFFF3A3)
            : isStreetwear
            ? const Color(0xFF00D9FF)
            : const Color(0xFFFFFFFF),
        fontSize: isStreetwear ? 34 : 32,
        isItalic: isStreetwear,
      ),
    );
  }

  DesignLayerModel _visibleTemplateLayer(TemplateModel template) {
    final normalized = template.title.trim().toLowerCase();
    final isAnime = normalized == 'anime' || template.id == '2';
    final isStreetwear = normalized == 'streetwear' || template.id == '1';
    final title = isAnime
        ? '\u0623\u0646\u0645\u064a'
        : isStreetwear
        ? '\u0633\u062a\u0631\u064a\u062a \u0648\u064a\u0631'
        : _safeTemplateTitle(template.title);

    return DesignLayerModel(
      id: 'template-${DateTime.now().millisecondsSinceEpoch}',
      type: LayerType.text,
      name: title,
      data: isStreetwear ? 'STREET' : title,
      size: const Size(220, 70),
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(105, 150),
      scale: 1.0,
      rotation: isStreetwear ? -0.08 : 0.0,
      textStyle: TextStyleModel.initial.copyWith(
        color: isAnime
            ? const Color(0xFFFFF3A3)
            : isStreetwear
            ? const Color(0xFF00D9FF)
            : const Color(0xFFFFFFFF),
        fontSize: isStreetwear ? 34 : 32,
        isItalic: isStreetwear,
      ),
    );
  }

  void openSavedDesign(SavedDesignModel design) {
    final data = design.designData;
    final productJson = data['product'];
    final canvas = data['canvas'];
    final layersJson = data['layers'];

    _saveHistory();

    final savedProduct = productJson is Map<String, dynamic>
        ? ProductTypeModel.fromJson(productJson)
        : null;
    final matchingProduct = savedProduct == null
        ? null
        : state.products.firstWhereOrNull(
            (product) => product.mockUpImage == savedProduct.mockUpImage,
          );

    final layers = layersJson is List
        ? layersJson
              .whereType<Map<String, dynamic>>()
              .map(DesignLayerModel.fromJson)
              .toList()
        : state.layers;

    emit(
      state.copyWith(
        selectedProduct: matchingProduct ?? state.selectedProduct,
        layers: layers,
        clearSelectedLayer: true,
        zoom: canvas is Map<String, dynamic>
            ? _double(canvas['zoom'], state.zoom)
            : state.zoom,
        rotation: canvas is Map<String, dynamic>
            ? _double(canvas['rotation'], state.rotation)
            : state.rotation,
        showSnapGuides: canvas is Map<String, dynamic>
            ? canvas['show_snap_guides'] != false
            : state.showSnapGuides,
      ),
    );
  }

  //  Export / Save

  Future<SavedDesignModel?> saveDesign() async {
    emit(state.copyWith(isSaving: true));
    final result = await _saveDesignUseCase(_savePayload());
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSaving: false,
            savedDesignsError: failure.message,
          ),
        );
        return null;
      },
      (design) {
        emit(state.copyWith(isSaving: false));
        fetchSavedDesigns();
        return design;
      },
    );
  }

  Future<CartItemModel?> addToCart() async {
    final product = state.selectedProduct;
    if (product == null) return null;

    emit(state.copyWith(isSaving: true, clearSavedDesignsError: true));
    final result = await _saveDesignUseCase(_savePayload());
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSaving: false,
            savedDesignsError: failure.message,
          ),
        );
        return null;
      },
      (design) {
        emit(
          state.copyWith(
            isSaving: false,
            savedDesigns: [design, ...state.savedDesigns],
            clearSavedDesignsError: true,
          ),
        );
        return _cartItemFromSavedDesign(design, product);
      },
    );
  }

  CartItemModel _cartItemFromSavedDesign(
    SavedDesignModel design,
    ProductTypeModel product,
  ) {
    final productTitle = _cartProductTitle(product.mockUpImage);

    return CartItemModel(
      id: 'design-${design.id}',
      designId: design.id,
      name: '$productTitle \u0645\u062e\u0635\u0635',
      price: _customProductPrice(product.mockUpImage),
      quantity: 1,
      imageUrl: product.mockUpImage,
      color: '\u0623\u0628\u064a\u0636',
      size: _defaultSize(product.mockUpImage),
      isCustomDesign: true,
      designData: _cartDesignData(design.id),
      previewImageUrl: design.previewImage,
    );
  }

  void togglePreviewMode() {
    emit(state.copyWith(previewMode: !state.previewMode));
  }

  //  Undo / Redo

  void undo() {
    if (_history.isEmpty) return;
    final previous = _history.removeLast();
    _redoStack.add(_DesignSnapshot.fromState(state));
    emit(previous.applyTo(state));
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final next = _redoStack.removeLast();
    _history.add(_DesignSnapshot.fromState(state));
    emit(next.applyTo(state));
  }

  //  Private Helpers

  void _saveHistory() {
    _history.add(_DesignSnapshot.fromState(state));
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
    _redoStack.clear();
  }

  List<DesignLayerModel> _updateLayerById(
    String id,
    DesignLayerModel Function(DesignLayerModel layer) update,
  ) {
    return state.layers.map((layer) {
      if (layer.id == id) return update(layer);
      return layer;
    }).toList();
  }

  void _emitWithLayers(
    List<DesignLayerModel> layers, {
    DesignLayerModel? selectedLayer,
    bool clearSelectedLayer = false,
  }) {
    final effectiveSelectedLayer = clearSelectedLayer
        ? null
        : (selectedLayer ??
              layers.firstWhereOrNull((l) => l.selected) ??
              state.selectedLayer);

    emit(
      state.copyWith(
        layers: layers,
        selectedLayer: effectiveSelectedLayer,
        clearSelectedLayer: clearSelectedLayer,
      ),
    );
  }

  Map<String, dynamic> _savePayload() {
    final templateId = int.tryParse(state.selectedTemplate?.id ?? '');
    final stickerIds = state.layers
        .where((layer) => layer.type == LayerType.sticker)
        .map((layer) {
          for (final sticker in state.stickers) {
            if (sticker.id > 0 && sticker.imageUrl == layer.data) {
              return sticker.id;
            }
          }
          return null;
        })
        .whereType<int>()
        .toSet()
        .toList();

    return {
      'name': 'تصميم ${_productTitle(state.selectedProduct?.mockUpImage)}',
      if (templateId != null) 'design_id': templateId,
      'design_data': {
        'product': state.selectedProduct?.toJson(),
        'template': state.selectedTemplate?.toJson(),
        'canvas': {
          'zoom': state.zoom,
          'rotation': state.rotation,
          'show_snap_guides': state.showSnapGuides,
        },
        'layers': state.layers.map((layer) => layer.toJson()).toList(),
      },
      if (stickerIds.isNotEmpty) 'sticker_ids': stickerIds,
    };
  }

  Map<String, dynamic> _cartDesignData(int designId) {
    return {
      'id': designId,
      'product': state.selectedProduct?.toJson(),
      'template': state.selectedTemplate?.toJson(),
      'canvas': {
        'zoom': state.zoom,
        'rotation': state.rotation,
        'show_snap_guides': state.showSnapGuides,
      },
      'layers': state.layers.map((layer) => layer.toJson()).toList(),
    };
  }
}

double _customProductPrice(String mockUpImage) {
  switch (mockUpImage) {
    case 'assets/images/design/hoodie.png':
      return 499;
    case 'assets/images/design/mug.png':
      return 199;
    case 'assets/images/design/tote-bag.png':
      return 249;
    case 'assets/images/design/case.png':
      return 229;
    case 'assets/images/design/t-shirt.png':
    default:
      return 299;
  }
}

String _defaultSize(String mockUpImage) {
  switch (mockUpImage) {
    case 'assets/images/design/mug.png':
    case 'assets/images/design/case.png':
      return '\u0642\u064a\u0627\u0633 \u0648\u0627\u062d\u062f';
    default:
      return 'M';
  }
}

String _cartProductTitle(String mockUpImage) {
  switch (mockUpImage) {
    case 'assets/images/design/t-shirt.png':
      return '\u062a\u064a\u0634\u064a\u0631\u062a';
    case 'assets/images/design/hoodie.png':
      return '\u0647\u0648\u062f\u064a';
    case 'assets/images/design/mug.png':
      return '\u0645\u062c';
    case 'assets/images/design/tote-bag.png':
      return '\u062a\u0648\u062a\u064a \u0628\u0627\u062c';
    case 'assets/images/design/case.png':
      return '\u062c\u0631\u0627\u0628 \u0647\u0627\u062a\u0641';
    default:
      return '\u0645\u0646\u062a\u062c';
  }
}

double _double(Object? value, double fallback) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

String _safeTemplateTitle(String title) {
  final normalized = title.trim().toLowerCase();
  if (normalized.isEmpty) return '\u0642\u0627\u0644\u0628';
  if (normalized == 'anime') return '\u0623\u0646\u0645\u064a';
  if (normalized == 'streetwear') {
    return '\u0633\u062a\u0631\u064a\u062a \u0648\u064a\u0631';
  }
  return title;
}

String _templateTitle(String title) {
  final normalized = title.trim().toLowerCase();
  if (normalized.isEmpty) return 'قالب';
  if (normalized == 'anime') return 'أنمي';
  if (normalized == 'streetwear') return 'ستريت وير';
  return title;
}

String _productTitle(String? mockUpImage) {
  switch (mockUpImage) {
    case 'assets/images/design/t-shirt.png':
      return 'تيشيرت';
    case 'assets/images/design/hoodie.png':
      return 'هودي';
    case 'assets/images/design/mug.png':
      return 'مج';
    case 'assets/images/design/tote-bag.png':
      return 'توتي باج';
    case 'assets/images/design/case.png':
      return 'جراب هاتف';
    default:
      return 'منتج';
  }
}

// Private Extensions

extension _FirstWhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class _DesignSnapshot {
  final ProductTypeModel? selectedProduct;
  final List<DesignLayerModel> layers;
  final DesignLayerModel? selectedLayer;
  final TemplateModel? selectedTemplate;
  final double zoom;
  final double rotation;
  final TextStyleModel activeTextStyle;

  const _DesignSnapshot({
    required this.selectedProduct,
    required this.layers,
    required this.selectedLayer,
    required this.selectedTemplate,
    required this.zoom,
    required this.rotation,
    required this.activeTextStyle,
  });

  factory _DesignSnapshot.fromState(DesignerState state) => _DesignSnapshot(
    selectedProduct: state.selectedProduct,
    layers: List.unmodifiable(state.layers),
    selectedLayer: state.selectedLayer,
    selectedTemplate: state.selectedTemplate,
    zoom: state.zoom,
    rotation: state.rotation,
    activeTextStyle: state.activeTextStyle,
  );

  DesignerState applyTo(DesignerState current) => current.copyWith(
    selectedProduct: selectedProduct,
    layers: layers,
    selectedLayer: selectedLayer,
    selectedTemplate: selectedTemplate,
    zoom: zoom,
    rotation: rotation,
    activeTextStyle: activeTextStyle,
  );
}
