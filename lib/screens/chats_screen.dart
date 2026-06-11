import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allChats = state.chats;

    // Filter chats based on search query
    final filteredChats = _searchQuery.isEmpty
        ? allChats
        : allChats
            .where((chat) =>
                chat.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Messages',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  if (state.totalUnread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${state.totalUnread}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  hintText: 'Search chats...',
                  prefixIcon:
                      Icon(Icons.search, color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredChats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mail_outline,
                              size: 64,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          const Text('No chats yet',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: filteredChats.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final chat = filteredChats[i];
                        return _ChatTile(chat: chat);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatThread chat;
  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppState>().markRead(chat.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(chat: chat),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with badge
            Stack(
              children: [
                Avatar(name: chat.name, color: chat.color, size: 56),
                if (chat.unread > 0)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${chat.unread}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: chat.unread > 0
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 15)),
                      ),
                      Text(chat.time,
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: chat.unread > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(chat.lastMessagePreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: chat.unread > 0
                              ? FontWeight.w500
                              : FontWeight.normal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
