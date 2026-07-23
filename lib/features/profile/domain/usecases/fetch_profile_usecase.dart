import '../../../../core/utils/result.dart';
import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class FetchProfileUseCase {
  const FetchProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<ProfileModel>> call() {
    return _repository.fetchProfile();
  }
}
