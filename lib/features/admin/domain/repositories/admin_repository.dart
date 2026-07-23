import '../../../../core/utils/result.dart';
import '../../data/models/admin_dashboard_model.dart';

abstract class AdminRepository {
  Future<Result<AdminDashboardModel>> fetchDashboard();
}
