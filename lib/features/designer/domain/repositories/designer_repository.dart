import '../../../../core/utils/result.dart';
import '../../data/models/designer_assets_model.dart';
import '../../data/models/saved_design_model.dart';

abstract class DesignerRepository {
  Future<Result<DesignerAssetsModel>> fetchAssets();

  Future<Result<SavedDesignModel>> saveDesign(Map<String, dynamic> data);

  Future<Result<List<SavedDesignModel>>> fetchSavedDesigns();
}
