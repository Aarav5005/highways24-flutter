import 'dart:async';
import 'package:dio/dio.dart';
import '../../features/auth/data/token_storage.dart';
import '../logging/app_logger.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && !options.headers.containsKey('Authorization')) {
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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    AppLogger.error('HTTP Error: [${err.response?.statusCode}] ${err.message}', err, err.stackTrace, 'NETWORK');

    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/')) {
      final newToken = await _handleTokenRefresh(err);
      if (newToken != null) {
        try {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          final dio = Dio();
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          if (e is DioException) {
            return handler.next(e);
          }
        }
      }
    }

    super.onError(err, handler);
  }

  Future<String?> _handleTokenRefresh(DioException err) async {
    if (_isRefreshing) {
      return await _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        await _tokenStorage.clearTokens();
        _refreshCompleter?.complete(null);
        return null;
      }

      final dio = Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl));
      final response = await dio.post('/auth/refresh-token', data: {'refresh_token': refreshToken});

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String? ?? data['accessToken'] as String? ?? '';
        await _tokenStorage.saveAccessToken(newAccessToken);
        _refreshCompleter?.complete(newAccessToken);
        return newAccessToken;
      } else {
        await _tokenStorage.clearTokens();
        _refreshCompleter?.complete(null);
        return null;
      }
    } catch (_) {
      await _tokenStorage.clearTokens();
      _refreshCompleter?.complete(null);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }
}
