import 'package:dio/dio.dart';
import '../../features/auth/data/token_storage.dart';
import '../logging/app_logger.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    AppLogger.info('HTTP Request: [${options.method}] ${options.path}', 'NETWORK');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info('HTTP Response: [${response.statusCode}] ${response.requestOptions.path}', 'NETWORK');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('HTTP Error: [${err.response?.statusCode}] ${err.message}', err, err.stackTrace, 'NETWORK');
    super.onError(err, handler);
  }
}
