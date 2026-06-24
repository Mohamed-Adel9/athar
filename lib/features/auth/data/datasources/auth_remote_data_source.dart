import '../../../../core/const_data/api_urls.dart';
import '../../../../core/services/dio_service.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});

  Future<AuthModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
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
      data: {'email': email, 'password': password},
    );

    return AuthModel.fromJson(_asMap(response.data));
  }

  @override
  Future<AuthModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dioService.post(
      url: ApiUrls.register,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
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
