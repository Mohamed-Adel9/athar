import '../../../../core/utils/result.dart';
import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<ProfileModel>> call({
    required String name,
    required String email,
  }) {
    return _repository.updateProfile(name: name, email: email);
  }
}
