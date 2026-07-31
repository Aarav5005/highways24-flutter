import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/auth_state.dart';

class AuthGuard {
  static String? redirectGuard(BuildContext context, GoRouterState state, AuthState authState) {
    final isLoggingIn = state.matchedLocation == '/' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/otp';

    if (authState is AuthUnauthenticated && !isLoggingIn) {
      return '/';
    }

    if (authState is AuthAuthenticated && isLoggingIn) {
      return '/home';
    }

    return null;
  }
}
