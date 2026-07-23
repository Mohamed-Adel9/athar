import '../../../../core/utils/result.dart';
import '../../data/models/saved_design_model.dart';
import '../repositories/designer_repository.dart';

class SaveDesignUseCase {
  const SaveDesignUseCase(this._repository);

  final DesignerRepository _repository;

  Future<Result<SavedDesignModel>> call(Map<String, dynamic> data) {
    return _repository.saveDesign(data);
  }
}
