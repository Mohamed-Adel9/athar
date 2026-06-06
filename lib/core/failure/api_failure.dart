import 'package:dio/dio.dart';

import 'api_config_exception.dart';
import 'failure.dart';

class ApiFailure extends Failure {
  ApiFailure(super.message);

  factory ApiFailure.fromException(Object error) {
    if (error is ApiConfigException) {
      return ApiFailure(error.message);
    }

    if (error is FormatException) {
      return ApiFailure(error.message);
    }

    if (error is DioException) {
      return ApiFailure(_dioMessage(error));
    }
    return ApiFailure(error.toString());
  }

  static String _dioMessage(DioException error) {
    final responseMessage = _responseMessage(error.response?.data);
    if (responseMessage != null) return responseMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        return _statusCodeMessage(error.response?.statusCode);
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return error.message ?? 'Something went wrong. Please try again.';
    }
  }

  static String? _responseMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.trim().isNotEmpty) return message;

      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }
        return firstValue.toString();
      }
    }
    return null;
  }

  static String _statusCodeMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your data.';
      case 401:
        return 'Invalid email or password.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'We could not find what you were looking for.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service is temporarily unavailable.';
      default:
        return 'Unexpected error. Please try again.';
    }
  }
}
