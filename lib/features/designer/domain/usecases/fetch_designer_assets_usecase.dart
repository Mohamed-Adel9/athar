import '../../../../core/utils/result.dart';
import '../../data/models/designer_assets_model.dart';
import '../repositories/designer_repository.dart';

class FetchDesignerAssetsUseCase {
  const FetchDesignerAssetsUseCase(this._repository);

  final DesignerRepository _repository;

  Future<Result<DesignerAssetsModel>> call() {
    return _repository.fetchAssets();
  }
}
