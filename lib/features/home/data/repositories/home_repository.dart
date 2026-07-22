import '../../../../core/failure/api_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<HomeDataEntity>> fetchHome() async {
    try {
      final home = await _remoteDataSource.fetchHome();
      return Success(home);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
