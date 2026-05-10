// import 'package:dio/dio.dart';
// import 'secure_storage_service.dart';
// import '../../const_data/api_urls.dart';
//
// class DioService {
//   final Dio _dio;
//   final SecureStorageService _storage;
//
//   DioService(this._storage)
//     : _dio = Dio(
//         BaseOptions(
//           baseUrl: ApiUrls.baseUrl,
//           receiveDataWhenStatusError: true,
//           connectTimeout: const Duration(seconds: 10),
//         ),
//       ) {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final token = await _storage.getToken();
//           if (token != null) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           options.headers['Accept'] = 'application/json';
//           options.headers['Content-Type'] = 'application/json';
//           return handler.next(options);
//         },
//         onError: (DioException e, handler) {
//           return handler.next(e);
//         },
//       ),
//     );
//   }
//
//   Future<Response> get({
//     required String url,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     var respone = await _dio.get(
//       url,
//       options: Options(headers: headers),
//       queryParameters: queryParameters,
//     );
//     return respone;
//   }
//
//   Future<Response> post({
//     required String url,
//     dynamic data,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     return await _dio.post(
//       url,
//       data: data,
//       options: Options(headers: headers),
//       queryParameters: queryParameters,
//     );
//   }
//
//   Future<Response> put({
//     required String url,
//     dynamic data,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     return await _dio.put(
//       url,
//       data: data,
//       options: Options(headers: headers),
//       queryParameters: queryParameters,
//     );
//   }
//
//   Future<Response> delete({
//     required String url,
//     dynamic data,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     return await _dio.delete(
//       url,
//       data: data,
//       options: Options(headers: headers),
//       queryParameters: queryParameters,
//     );
//   }
// }
