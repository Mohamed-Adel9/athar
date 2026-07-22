import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/home_models.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> fetchHome();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<HomeDataModel> fetchHome() async {
    final response = await _dioService.get(url: ApiUrls.home);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Unexpected home response format.');
    }

    return HomeResponseModel.fromJson(data).data;
  }
}
