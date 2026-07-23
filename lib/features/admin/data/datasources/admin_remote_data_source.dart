import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/admin_dashboard_model.dart';

abstract class AdminRemoteDataSource {
  Future<AdminDashboardModel> fetchDashboard();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  const AdminRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<AdminDashboardModel> fetchDashboard() async {
    final response = await _dioService.get(url: ApiUrls.adminDashboard);
    return AdminDashboardModel.fromJson(_map(response.data));
  }
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}
