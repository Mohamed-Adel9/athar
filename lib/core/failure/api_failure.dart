// // ignore_for_file: use_super_parameters
//
// import 'failure.dart';
//
// class ApiFailure extends Failure {
//   ApiFailure(String message) : super(message);
//
//   static String dioError(dynamic error) {
//     if (error is DioException) {
//       switch (error.type) {
//         case DioExceptionType.connectionTimeout:
//         case DioExceptionType.sendTimeout:
//         case DioExceptionType.receiveTimeout:
//           return "Connection timed out. Please check your internet and try again.";
//         case DioExceptionType.badResponse:
//           return statusCode(error.response?.statusCode);
//         case DioExceptionType.connectionError:
//           return "No internet connection. Please turn on Wi-Fi or mobile data.";
//         case DioExceptionType.cancel:
//           return "The request was cancelled.";
//         default:
//           return "Oops! Something went wrong. Please try again later.";
//       }
//     }
//     return error.toString();
//   }
//
//   static String statusCode(int? statusCode) {
//     switch (statusCode) {
//       case 400:
//         return "Invalid email or password. Please try again.";
//       case 401:
//         return "Your session has expired. Please log in again.";
//       case 403:
//         return "You don't have permission to perform this action.";
//       case 404:
//         return "We couldn't find what you were looking for.";
//       case 500:
//         return "Our server is having a moment. We're working on fixing it!";
//       case 503:
//         return "The service is temporarily unavailable. Try again in a few minutes.";
//       default:
//         return "Unexpected error ($statusCode). Please try again.";
//     }
//   }
// }
