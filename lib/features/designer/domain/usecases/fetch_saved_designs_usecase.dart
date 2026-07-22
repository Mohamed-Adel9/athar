import '../../../../core/utils/result.dart';
import '../../data/models/saved_design_model.dart';
import '../repositories/designer_repository.dart';

class FetchSavedDesignsUseCase {
  const FetchSavedDesignsUseCase(this._repository);

  final DesignerRepository _repository;

  Future<Result<List<SavedDesignModel>>> call() {
    return _repository.fetchSavedDesigns();
  }
}
