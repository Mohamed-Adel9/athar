import 'package:athar/core/network/dio_service.dart';
import 'package:dio/dio.dart';

import '../../../../core/const_data/api_urls.dart';

class SplashData {
  final DioService dioService;
  SplashData({required this.dioService});

  Future<Response> login() async {
    return await dioService.get(url: ApiUrls.login);
  }
}
