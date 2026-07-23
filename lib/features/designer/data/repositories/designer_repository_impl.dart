import '../../../../core/failure/api_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/designer_repository.dart';
import '../datasources/designer_remote_data_source.dart';
import '../models/designer_assets_model.dart';
import '../models/saved_design_model.dart';

class DesignerRepositoryImpl implements DesignerRepository {
  const DesignerRepositoryImpl(this._remoteDataSource);

  final DesignerRemoteDataSource _remoteDataSource;

  @override
  Future<Result<DesignerAssetsModel>> fetchAssets() async {
    try {
      final assets = await _remoteDataSource.fetchAssets();
      return Success(assets);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<SavedDesignModel>> saveDesign(Map<String, dynamic> data) async {
    try {
      final design = await _remoteDataSource.saveDesign(data);
      return Success(design);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<List<SavedDesignModel>>> fetchSavedDesigns() async {
    try {
      final designs = await _remoteDataSource.fetchSavedDesigns();
      return Success(designs);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
