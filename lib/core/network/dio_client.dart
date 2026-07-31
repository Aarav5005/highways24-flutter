import 'package:dio/dio.dart';
import '../../app/env/app_env.dart';
import '../../features/auth/data/token_storage.dart';
import 'auth_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient(TokenStorage tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(AuthInterceptor(tokenStorage));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }
}
