import '../../../core/errors/result.dart';
import 'user_model.dart';

abstract class AuthRepository {
  Future<Result<void>> sendOtp(String phone);
  Future<Result<UserModel>> verifyOtp(String phone, String otp);
  Future<Result<String>> refreshToken();
  Future<Result<UserModel>> getCurrentUser();
  Future<Result<void>> logout();
}
