import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final chats = state.chats
        .where((c) => c.name.toLowerCase().contains(_q.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            const Text('Chats',
                style:
                    TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: const InputDecoration(
                hintText: 'Search chats...',
                prefixIcon:
                    Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 8),
            ...chats.map((c) => ChatTile(thread: c)),
          ],
        ),
      ),
    );
  }
}
