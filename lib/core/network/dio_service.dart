import 'package:dio/dio.dart';

import '../const_data/api_urls.dart';
import '../failure/api_config_exception.dart';
import '../services/secure_storage_service.dart';

class DioService {
  DioService(this._storage)
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final SecureStorageService _storage;

  Future<Response<dynamic>> get({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    _ensureConfigured();
    return _dio.get(
      url,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
  }

  Future<Response<dynamic>> post({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    _ensureConfigured();
    return _dio.post(
      url,
      data: data,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
  }

  Future<Response<dynamic>> put({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    _ensureConfigured();
    return _dio.put(
      url,
      data: data,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
  }

  Future<Response<dynamic>> delete({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    _ensureConfigured();
    return _dio.delete(
      url,
      data: data,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
  }

  void _ensureConfigured() {
    if (ApiUrls.baseUrl.trim().isEmpty) {
      throw const ApiConfigException(
        'API base URL is not configured. Run the app with --dart-define=API_BASE_URL=https://your-domain.com/api/',
      );
    }
  }
}
