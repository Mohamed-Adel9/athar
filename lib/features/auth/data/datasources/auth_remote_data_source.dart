import '../../../../core/const_data/api_urls.dart';
import '../../../../core/services/dio_service.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String email,
    required String password,
  });

  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioService.post(
      url: ApiUrls.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthModel.fromJson(_asMap(response.data));
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dioService.post(
      url: ApiUrls.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return AuthModel.fromJson(_asMap(response.data));
  }

  @override
  Future<void> logout() async {
    await _dioService.post(url: ApiUrls.logout);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw const FormatException('Unexpected API response format.');
  }
}
