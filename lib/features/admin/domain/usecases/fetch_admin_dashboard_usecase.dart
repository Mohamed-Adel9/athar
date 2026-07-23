import '../../../../core/utils/result.dart';
import '../../data/models/admin_dashboard_model.dart';
import '../repositories/admin_repository.dart';

class FetchAdminDashboardUseCase {
  const FetchAdminDashboardUseCase(this._repository);

  final AdminRepository _repository;

  Future<Result<AdminDashboardModel>> call() {
    return _repository.fetchDashboard();
  }
}
