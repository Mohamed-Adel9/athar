import 'package:dio/dio.dart';

import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';

abstract class AuthRemoteDataSource {
  Future<Response> login({required String email, required String password});

  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<Response> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _dioService.post(
        url: ApiUrls.login,
        data: {'email': email, 'password': password},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      return await _dioService.post(
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> logout() async {
    try {
      return await _dioService.post(url: ApiUrls.logout);
    } catch (e) {
      rethrow;
    }
  }
}
