import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HighwaySetuApp());
}

class HighwaySetuApp extends StatelessWidget {
  const HighwaySetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Highway Setu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const WelcomeScreen(),
      ),
    );
  }
}
