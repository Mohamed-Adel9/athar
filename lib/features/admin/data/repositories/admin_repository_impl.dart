import '../../../../core/failure/api_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';
import '../models/admin_dashboard_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl(this._remoteDataSource);

  final AdminRemoteDataSource _remoteDataSource;

  @override
  Future<Result<AdminDashboardModel>> fetchDashboard() async {
    try {
      final dashboard = await _remoteDataSource.fetchDashboard();
      return Success(dashboard);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
