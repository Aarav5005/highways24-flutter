import '../../../core/network/dio_client.dart';
import 'dto/send_otp_request.dart';
import 'dto/verify_otp_request.dart';
import 'dto/auth_response_dto.dart';
import 'dto/user_dto.dart';

class AuthApi {
  final DioClient _dioClient;

  AuthApi(this._dioClient);

  Future<void> sendOtp(SendOtpRequest request) async {
    await _dioClient.post('/auth/send-otp', data: request.toJson());
  }

  Future<AuthResponseDto> verifyOtp(VerifyOtpRequest request) async {
    final response = await _dioClient.post('/auth/verify-otp', data: request.toJson());
    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _dioClient.post(
      '/auth/refresh-token',
      data: {'refresh_token': refreshToken},
    );
    final data = response.data as Map<String, dynamic>;
    return data['access_token'] as String? ?? data['accessToken'] as String? ?? '';
  }

  Future<UserDto> getCurrentUser() async {
    final response = await _dioClient.get('/auth/me');
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _dioClient.post('/auth/logout');
  }
}
