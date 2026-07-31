import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../domain/auth_state.dart';
import '../data/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(tokenStorageProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final TokenStorage _tokenStorage;

  AuthNotifier(this._tokenStorage) : super(const AuthUnauthenticated()) {
    restoreSession();
  }

  // Restore Session on Launch
  Future<void> restoreSession() async {
    final token = await _tokenStorage.getAccessToken();
    final refresh = await _tokenStorage.getRefreshToken();
    final roleStr = await _tokenStorage.getUserRole();

    if (token != null && refresh != null) {
      final role = UserRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserRole.driver,
      );

      final user = UserModel(
        id: 'usr_restored',
        name: 'Rajesh Singh',
        phone: '+91 98765 43210',
        email: 'driver@highway.in',
        role: role,
        vehicleNumber: 'HR 26 DQ 8821',
        vehicleType: '12-Wheeler Truck',
      );

      state = AuthAuthenticated(user: user, accessToken: token, refreshToken: refresh);
    } else {
      state = const AuthUnauthenticated();
    }
  }

  // Submit Phone OTP Verification
  Future<void> verifyOtp(String phone, String otp, UserRole role) async {
    state = const AuthAuthenticating();
    await Future.delayed(const Duration(milliseconds: 600));

    if (otp == '123456') {
      const access = 'mock_jwt_access_token_12345';
      const refresh = 'mock_jwt_refresh_token_67890';

      await _tokenStorage.saveTokens(accessToken: access, refreshToken: refresh);
      await _tokenStorage.saveUserRole(role.name);

      final user = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Rajesh Singh',
        phone: phone,
        email: 'driver@highway.in',
        role: role,
      );

      state = AuthAuthenticated(user: user, accessToken: access, refreshToken: refresh);
    } else {
      state = const AuthFailure('Invalid OTP Code. Please enter 123456.');
    }
  }

  // Logout & Clear Encrypted Tokens
  Future<void> logout() async {
    await _tokenStorage.clearAll();
    state = const AuthUnauthenticated();
  }
}
