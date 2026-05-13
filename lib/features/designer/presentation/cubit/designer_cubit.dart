import 'dart:ui';

import 'designer_state.dart';
import '../../data/models/template_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/text_style_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/design_layer_model.dart';
import '../../../../core/services/image_picker_service.dart';

class DesignerCubit extends Cubit<DesignerState> {
  DesignerCubit() : super(DesignerState.initial());

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
      name: 'Text Layer',
      data: 'ATHAR',
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
      name: 'Image Layer',
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
      name: 'Sticker Layer',
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
      emit(state.copyWith(
        layers: updatedLayers,
        selectedLayer: null,
        clearSelectedLayer: true,
      ));
    } else {
      _emitWithLayers(updatedLayers);
    }
  }

  void reorderLayers(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= state.layers.length) return;
    if (newIndex < 0 || newIndex > state.layers.length) return;
    if (oldIndex == newIndex) return;

    _saveHistory();

    final updated = List <DesignLayerModel>.from(state.layers);
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

    emit(state.copyWith(
      layers: updated,
      selectedLayer: target.copyWith(selected: true),
    ));
  }

  /// NEW: Unselect everything when tapping empty canvas
  void unselectAll() {
    if (state.selectedLayer == null) return;

    final updated = state.layers
        .map((e) => e.copyWith(selected: false))
        .toList();

    emit(state.copyWith(
      layers: updated,
      selectedLayer: null,
      clearSelectedLayer: true,
    ));
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

  //  Export / Save

  Future<void> saveDesign() async {
    emit(state.copyWith(isSaving: true));
    // TODO: Replace with actual save logic
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isSaving: false));
  }

  void addToCart() {
    // TODO: Implement add to cart
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

    emit(state.copyWith(
      layers: layers,
      selectedLayer: effectiveSelectedLayer,
      clearSelectedLayer: clearSelectedLayer,
    ));
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
