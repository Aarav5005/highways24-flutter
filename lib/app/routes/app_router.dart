import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/auth/phone_login_screen.dart';
import '../../screens/home_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const PhoneLoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) => const HomeShell(),
    ),
  ],
);
