import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CampConnectApp());
}

class CampConnectApp extends StatelessWidget {
  const CampConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Camp Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decides which screen to show based on auth state.
/// This is the top-level "navigation switch" of the app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AppState>().isLoggedIn;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: loggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
