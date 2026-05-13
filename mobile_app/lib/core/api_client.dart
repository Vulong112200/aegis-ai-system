import 'package:dio/dio.dart';
import 'constants.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Dio get dio => _dio;

  // Add interceptors for JWT token
  static void addInterceptors(String? token) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}