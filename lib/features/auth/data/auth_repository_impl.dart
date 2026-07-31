import 'package:dio/dio.dart';
import '../../../core/errors/result.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/auth_repository.dart';
import '../domain/user_model.dart';
import 'auth_api.dart';
import 'token_storage.dart';
import 'dto/send_otp_request.dart';
import 'dto/verify_otp_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._authApi, this._tokenStorage);

  @override
  Future<Result<void>> sendOtp(String phone) async {
    try {
      await _authApi.sendOtp(SendOtpRequest(phone: phone));
      return Result.success(null);
    } catch (e) {
      return Result.failure(_mapToAppException(e));
    }
  }

  @override
  Future<Result<UserModel>> verifyOtp(String phone, String otp) async {
    try {
      final response = await _authApi.verifyOtp(VerifyOtpRequest(phone: phone, otp: otp));
      await _tokenStorage.saveAccessToken(response.accessToken);
      await _tokenStorage.saveRefreshToken(response.refreshToken);
      await _tokenStorage.saveUserRole(response.user.role);

      return Result.success(response.user.toDomain());
    } catch (e) {
      return Result.failure(_mapToAppException(e));
    }
  }

  @override
  Future<Result<String>> refreshToken() async {
    try {
      final currentRefresh = await _tokenStorage.getRefreshToken();
      if (currentRefresh == null) {
        return Result.failure(const AuthException('No refresh token available'));
      }
      final newAccessToken = await _authApi.refreshToken(currentRefresh);
      await _tokenStorage.saveAccessToken(newAccessToken);
      return Result.success(newAccessToken);
    } catch (e) {
      await _tokenStorage.clearTokens();
      return Result.failure(_mapToAppException(e));
    }
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    try {
      final userDto = await _authApi.getCurrentUser();
      return Result.success(userDto.toDomain());
    } catch (e) {
      return Result.failure(_mapToAppException(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // Ignore network errors on logout, clear tokens locally regardless
    } finally {
      await _tokenStorage.clearTokens();
    }
    return Result.success(null);
  }

  AppException _mapToAppException(dynamic error) {
    if (error is AppException) return error;

    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data?['message'] as String? ?? error.message ?? 'Network error';

      if (statusCode == 401 || statusCode == 403) {
        return AuthException(message, statusCode: statusCode);
      }
      if (statusCode != null && statusCode >= 500) {
        return ServerException(message, statusCode: statusCode);
      }
      return NetworkException(message, statusCode: statusCode);
    }

    return AppException(error.toString());
  }
}
