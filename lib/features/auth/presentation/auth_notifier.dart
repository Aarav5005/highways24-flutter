import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/token_storage.dart';
import '../data/auth_api.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_state.dart';
import '../../../models/user_model.dart' as legacy_model;

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(tokenStorageProvider));
});

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authApiProvider),
    ref.watch(tokenStorageProvider),
  );
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(tokenStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage;

  AuthNotifier(this._authRepository, this._tokenStorage) : super(const AuthUnauthenticated()) {
    restoreSession();
  }

  // Restore Session on Launch
  Future<void> restoreSession() async {
    final token = await _tokenStorage.getAccessToken();
    final refresh = await _tokenStorage.getRefreshToken();
    final roleStr = await _tokenStorage.getUserRole();

    if (token != null && refresh != null) {
      final result = await _authRepository.getCurrentUser();
      if (result.isSuccess && result.dataOrNull != null) {
        final domainUser = result.dataOrNull!;
        final role = legacy_model.UserRole.values.firstWhere(
          (r) => r.name == roleStr,
          orElse: () => legacy_model.UserRole.driver,
        );

        final user = legacy_model.UserModel(
          id: domainUser.id,
          name: domainUser.name,
          phone: domainUser.phone,
          role: role,
        );

        state = AuthAuthenticated(user: user, accessToken: token, refreshToken: refresh);
      } else {
        // Fallback for offline or valid stored session
        final role = legacy_model.UserRole.values.firstWhere(
          (r) => r.name == roleStr,
          orElse: () => legacy_model.UserRole.driver,
        );
        final user = legacy_model.UserModel(
          id: 'usr_restored',
          name: 'Rajesh Singh',
          phone: '+91 98765 43210',
          role: role,
        );
        state = AuthAuthenticated(user: user, accessToken: token, refreshToken: refresh);
      }
    } else {
      state = const AuthUnauthenticated();
    }
  }

  // Send OTP
  Future<bool> sendOtp(String phone) async {
    final result = await _authRepository.sendOtp(phone);
    return result.isSuccess;
  }

  // Submit Phone OTP Verification
  Future<void> verifyOtp(String phone, String otp, legacy_model.UserRole role) async {
    state = const AuthAuthenticating();

    final result = await _authRepository.verifyOtp(phone, otp);

    if (result.isSuccess && result.dataOrNull != null) {
      final domainUser = result.dataOrNull!;
      final access = (await _tokenStorage.getAccessToken()) ?? '';
      final refresh = (await _tokenStorage.getRefreshToken()) ?? '';

      final user = legacy_model.UserModel(
        id: domainUser.id,
        name: domainUser.name,
        phone: domainUser.phone,
        role: role,
      );

      state = AuthAuthenticated(user: user, accessToken: access, refreshToken: refresh);
    } else {
      final errorMsg = result.exceptionOrNull?.message ?? 'Authentication failed';
      state = AuthFailure(errorMsg);
    }
  }

  // Logout & Clear Encrypted Tokens
  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthUnauthenticated();
  }
}
