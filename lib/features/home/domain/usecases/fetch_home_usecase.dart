import '../../../../core/utils/result.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class FetchHomeUseCase {
  const FetchHomeUseCase(this._repository);

  final HomeRepository _repository;

  Future<Result<HomeDataEntity>> call() {
    return _repository.fetchHome();
  }
}
