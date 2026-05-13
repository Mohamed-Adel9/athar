import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/design_layer_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/text_style_model.dart';
import 'designer_state.dart';

class DesignerCubit extends Cubit<DesignerState> {
  DesignerCubit()
    : super(
        DesignerState(
          products: const [
            ProductTypeModel(
              title: 'تيشرت',
              mockUpImage: "assets/images/design/t-shirt.png",
            ),
            ProductTypeModel(
              title: 'هودي',
              mockUpImage: "assets/images/design/hoodie.png",
            ),
            ProductTypeModel(
              title: 'مج',
              mockUpImage: "assets/images/design/mug.png",
            ),
            ProductTypeModel(
              title: 'توتي باج',
              mockUpImage: "assets/images/design/tote-bag.png",
            ),
            ProductTypeModel(
              title: 'جراب هاتف',
              mockUpImage: "assets/images/design/case.png",
            ),
          ],
          selectedProduct: const ProductTypeModel(
            title: 'تيشرت',
            mockUpImage: "assets/images/design/t-shirt.png",
          ),
          layers: const [],
          selectedLayer: null,
          templates: const [
            TemplateModel(
              id: '1',
              title: 'Streetwear',
              icon: Icons.bolt_rounded,
              selected: true,
            ),
            TemplateModel(
              id: '2',
              title: 'Anime',
              icon: Icons.auto_awesome_rounded,
              selected: false,
            ),
          ],
          selectedTemplate: null,
          zoom: 1,
          rotation: 0,
          aiPrompt: '',
          isGenerating: false,
          isSaving: false,
          showLayersPanel: true,
          previewMode: false,
          showSnapGuides: true,
          showToolbar: true,
          selectedTool: DesignerTool.none,
          activeTextStyle: TextStyleModel.initial(),
          undoStack: [],
          redoStack: [],
        ),
      );

  void _saveHistory() {
    emit(state.copyWith(undoStack: [...state.undoStack, state], redoStack: []));
  }

  void selectProduct(ProductTypeModel product) {
    _saveHistory();

    emit(state.copyWith(selectedProduct: product));
  }

  void moveLayer(String id, Offset delta) {
    emit(
      state.copyWith(
        layers: state.layers.map((layer) {
          if (layer.id == id) {
            return layer.copyWith(position: layer.position + delta);
          }
          return layer;
        }).toList(),
      ),
    );
  }

  void zoomIn() {
    emit(state.copyWith(zoom: min(state.zoom + .1, 3)));
  }

  void zoomOut() {
    emit(state.copyWith(zoom: max(state.zoom - .1, .5)));
  }

  void rotateCanvas() {
    emit(state.copyWith(rotation: state.rotation + .1));
  }

  void resetCanvas() {
    emit(state.copyWith(zoom: 1, rotation: 0));
  }

  void toggleGrid() {
    emit(state.copyWith(showSnapGuides: !state.showSnapGuides));
  }

  void toggleLayersPanel() {
    emit(state.copyWith(showLayersPanel: !state.showLayersPanel));
  }

  void addTextLayer() {
    final layer = DesignLayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.text,
      name: 'Text Layer',
      data: 'ATHAR',
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(120, 160),
      scale: 1,
      rotation: 0,
      textStyle: state.activeTextStyle,
    );

    final updatedLayers = [
      ...state.layers.map((e) => e.copyWith(selected: false)),
      layer,
    ];

    emit(state.copyWith(layers: updatedLayers, selectedLayer: layer));
  }

  void addImageLayer() {
    final layer = DesignLayerModel(
      id: DateTime.now().toString(),
      type: LayerType.image,
      name: 'Image Layer',
      data: '',
      visible: true,
      locked: false,
      selected: true,
      position: const Offset(100, 220),
      scale: 1,
      rotation: 0,
    );

    emit(
      state.copyWith(layers: [...state.layers, layer], selectedLayer: layer),
    );
  }

  void addStickerLayer() {}

  void removeLayer(String id) {
    emit(
      state.copyWith(layers: state.layers.where((e) => e.id != id).toList()),
    );
  }

  void reorderLayers(int oldIndex, int newIndex) {
    final updated = [...state.layers];

    final item = updated.removeAt(oldIndex);

    updated.insert(newIndex, item);

    emit(state.copyWith(layers: updated));
  }

  void toggleLayerVisibility(String id) {
    emit(
      state.copyWith(
        layers: state.layers.map((e) {
          if (e.id == id) {
            return e.copyWith(visible: !e.visible);
          }

          return e;
        }).toList(),
      ),
    );
  }

  void lockLayer(String id) {
    emit(
      state.copyWith(
        layers: state.layers.map((e) {
          if (e.id == id) {
            return e.copyWith(locked: !e.locked);
          }

          return e;
        }).toList(),
      ),
    );
  }

  void selectLayer(String id) {
    final updated = state.layers.map((e) {
      return e.copyWith(selected: e.id == id);
    }).toList();

    emit(
      state.copyWith(
        layers: updated,
        selectedLayer: updated.firstWhere((e) => e.id == id),
      ),
    );
  }

  void updateText(String value) {
    if (state.selectedLayer == null) return;

    final updated = state.layers.map((e) {
      if (e.id == state.selectedLayer!.id) {
        return e.copyWith(data: value);
      }

      return e;
    }).toList();

    emit(state.copyWith(layers: updated));
  }

  void updateFontFamily(String family) {
    final style = state.activeTextStyle.copyWith(fontFamily: family);

    emit(state.copyWith(activeTextStyle: style));
  }

  void updateFontSize(double size) {
    emit(
      state.copyWith(
        activeTextStyle: state.activeTextStyle.copyWith(fontSize: size),
      ),
    );
  }

  void toggleBold() {
    emit(
      state.copyWith(
        activeTextStyle: state.activeTextStyle.copyWith(
          isBold: !state.activeTextStyle.isBold,
        ),
      ),
    );
  }

  void toggleItalic() {
    emit(
      state.copyWith(
        activeTextStyle: state.activeTextStyle.copyWith(
          isItalic: !state.activeTextStyle.isItalic,
        ),
      ),
    );
  }

  void updateTextColor(Color color) {
    emit(
      state.copyWith(
        activeTextStyle: state.activeTextStyle.copyWith(color: color),
      ),
    );
  }

  void updatePrompt(String value) {
    emit(state.copyWith(aiPrompt: value));
  }

  Future<void> generateAiDesign() async {
    emit(state.copyWith(isGenerating: true));

    await Future.delayed(const Duration(seconds: 2));

    addImageLayer();

    emit(state.copyWith(isGenerating: false));
  }

  void selectTemplate(TemplateModel template) {
    emit(state.copyWith(selectedTemplate: template));
  }

  Future<void> saveDesign() async {
    emit(state.copyWith(isSaving: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isSaving: false));
  }

  void addToCart() {}

  void togglePreviewMode() {
    emit(state.copyWith(previewMode: !state.previewMode));
  }

  void undo() {
    if (state.undoStack.isEmpty) return;

    final previous = state.undoStack.last;

    final updatedUndo = [...state.undoStack]..removeLast();

    emit(
      previous.copyWith(
        undoStack: updatedUndo,
        redoStack: [...state.redoStack, state],
      ),
    );
  }

  void redo() {
    if (state.redoStack.isEmpty) return;

    final next = state.redoStack.last;

    final updatedRedo = [...state.redoStack]..removeLast();

    emit(next.copyWith(redoStack: updatedRedo));
  }
}
