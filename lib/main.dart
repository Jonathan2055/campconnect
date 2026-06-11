import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chats_screen.dart';
import 'screens/communities_screen.dart';
import 'screens/create_post_screen.dart';
import 'theme/app_theme.dart';

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
      child: loggedIn ? const MainShell() : const LoginScreen(),
    );
  }
}

/// Bottom-tab navigation shell for the main app.
/// Provides access to Home, Chats, Communities, and Create Post screens.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ChatsScreen(),
    CommunitiesScreen(),
    CreatePostScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              label:
                  state.totalUnread > 0 ? Text('${state.totalUnread}') : null,
              child: const Icon(Icons.mail_outline),
            ),
            selectedIcon: Badge(
              label:
                  state.totalUnread > 0 ? Text('${state.totalUnread}') : null,
              child: const Icon(Icons.mail),
            ),
            label: 'Chats',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Communities',
          ),
          const NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Post',
          ),
        ],
      ),
    );
  }
}
