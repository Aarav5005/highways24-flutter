import '../../../models/user_model.dart';

abstract class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  const AuthAuthenticated({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}

class AuthRefreshingToken extends AuthState {
  const AuthRefreshingToken();
}

class AuthSessionExpired extends AuthState {
  const AuthSessionExpired();
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}
