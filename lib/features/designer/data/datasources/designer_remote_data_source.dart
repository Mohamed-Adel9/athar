import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/design_sticker_model.dart';
import '../models/designer_assets_model.dart';
import '../models/saved_design_model.dart';
import '../models/template_model.dart';

abstract class DesignerRemoteDataSource {
  Future<DesignerAssetsModel> fetchAssets();

  Future<SavedDesignModel> saveDesign(Map<String, dynamic> data);

  Future<List<SavedDesignModel>> fetchSavedDesigns();
}

class DesignerRemoteDataSourceImpl implements DesignerRemoteDataSource {
  const DesignerRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<DesignerAssetsModel> fetchAssets() async {
    final responses = await Future.wait([
      _dioService.get(url: ApiUrls.designTemplates),
      _dioService.get(url: ApiUrls.designStickers),
    ]);

    return DesignerAssetsModel(
      templates: _list(
        _map(_map(responses[0].data)['data'])['templates'],
      ).map(TemplateModel.fromJson).toList(),
      stickers: _list(
        _map(_map(responses[1].data)['data'])['stickers'],
      ).map(DesignStickerModel.fromJson).toList(),
    );
  }

  @override
  Future<SavedDesignModel> saveDesign(Map<String, dynamic> data) async {
    final response = await _dioService.post(url: ApiUrls.savedDesigns, data: data);
    final payload = _map(response.data);
    final savedDesign = _map(payload['data']).isEmpty ? payload : _map(payload['data']);
    return SavedDesignModel.fromJson(savedDesign);
  }

  @override
  Future<List<SavedDesignModel>> fetchSavedDesigns() async {
    final response = await _dioService.get(url: ApiUrls.savedDesigns);
    final designs = _map(_map(response.data)['data'])['designs'];
    if (designs is Map<String, dynamic>) {
      return _list(designs['data']).map(SavedDesignModel.fromJson).toList();
    }
    return _list(designs).map(SavedDesignModel.fromJson).toList();
  }
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return [];
  return value.whereType<Map<String, dynamic>>().toList();
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}
