import '../../../../core/utils/result.dart';
import '../repositories/designer_repository.dart';

class SaveDesignUseCase {
  const SaveDesignUseCase(this._repository);

  final DesignerRepository _repository;

  Future<Result<void>> call(Map<String, dynamic> data) {
    return _repository.saveDesign(data);
  }
}
