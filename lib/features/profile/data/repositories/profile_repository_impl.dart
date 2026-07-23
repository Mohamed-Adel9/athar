import '../../../../core/failure/api_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ProfileModel>> fetchProfile() async {
    try {
      final profile = await _remoteDataSource.fetchProfile();
      return Success(profile);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<ProfileModel>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final profile = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
      );
      return Success(profile);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
