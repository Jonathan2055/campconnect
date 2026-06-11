import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'feed_screen.dart';
import 'explore_screen.dart';
import 'chats_screen.dart';
import 'profile_screen.dart';
import 'create_post_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    FeedScreen(),
    ExploreScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  void _openCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<AppState>().totalUnread;
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.emerald,
        foregroundColor: AppColors.onEmerald,
        elevation: 2,
        shape: const CircleBorder(),
        onPressed: _openCreate,
        child: const Icon(Icons.add, size: 26),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.dark,
        indicatorColor: AppColors.emerald.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white54),
            selectedIcon:
                Icon(Icons.home_rounded, color: AppColors.emerald),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.dynamic_feed_outlined, color: Colors.white54),
            selectedIcon:
                Icon(Icons.dynamic_feed_rounded, color: AppColors.emerald),
            label: 'Feed',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined, color: Colors.white54),
            selectedIcon:
                Icon(Icons.search_rounded, color: AppColors.emerald),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: unread > 0
                ? Badge.count(
                    count: unread,
                    child: const Icon(Icons.chat_bubble_outline_rounded,
                        color: Colors.white54),
                  )
                : const Icon(Icons.chat_bubble_outline_rounded,
                    color: Colors.white54),
            selectedIcon: unread > 0
                ? Badge.count(
                    count: unread,
                    child: const Icon(Icons.chat_bubble_rounded,
                        color: AppColors.emerald),
                  )
                : const Icon(Icons.chat_bubble_rounded,
                    color: AppColors.emerald),
            label: 'Chats',
          ),
          const NavigationDestination(
            icon:
                Icon(Icons.person_outline_rounded, color: Colors.white54),
            selectedIcon:
                Icon(Icons.person_rounded, color: AppColors.emerald),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
