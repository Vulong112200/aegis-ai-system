import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants.dart';

// Provide Dio instance via Riverpod for global access
final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add an interceptor for logging in debug mode
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print('🌐 [API REQ] ${options.method} ${options.uri}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print('✅ [API RES] ${response.statusCode} ${response.requestOptions.path}');
      return handler.next(response);
    },
    onError: (DioException e, handler) {
      print('❌ [API ERR] ${e.response?.statusCode} ${e.requestOptions.path}');
      return handler.next(e);
    },
  ));

  return dio;
});