class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const AppException(this.message, {this.code, this.statusCode});

  @override
  String toString() => 'AppException: [$code] $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.statusCode});
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.statusCode});
}

class ServerException extends AppException {
  const ServerException(super.message, {super.code, super.statusCode});
}
