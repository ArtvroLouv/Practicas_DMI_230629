import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:dio/dio.dart';

String movieLoadErrorMessage(Object? error, AppStrings strings) {
  if (error is StateError &&
      error.message.toString().contains('THE_MOVIEDB_KEY')) {
    return strings.tmdbKeyMissing;
  }

  if (error is DioException) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return strings.tmdbKeyInvalid;
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return strings.connectionError;
    }
  }

  return strings.loadError;
}
