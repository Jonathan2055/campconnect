import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatThread thread;
  const ChatDetailScreen({super.key, required this.thread});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    context.read<AppState>().sendMessage(widget.thread.id, _controller.text);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>(); // rebuild when a new message is added
    final thread = widget.thread;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        titleSpacing: 0,
        title: Row(
          children: [
            Avatar(name: thread.name, color: thread.color, size: 36),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(thread.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                if (thread.isGroup)
                  Text('${thread.membersCount} members',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
        actions: const [Icon(Icons.more_vert), SizedBox(width: 12)],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(16),
                itemCount: thread.messages.length,
                itemBuilder: (_, i) => _bubble(thread.messages[i]),
              ),
            ),
            _composer(),
          ],
        ),
      ),
    );
  }

  Widget _bubble(Message m) {
    final align = m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = m.isMe ? AppColors.emerald : AppColors.surface;
    final textColor = m.isMe ? AppColors.onEmerald : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (!m.isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(m.sender,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(m.isMe ? 16 : 4),
                bottomRight: Radius.circular(m.isMe ? 4 : 16),
              ),
            ),
            child: m.attachmentName != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.insert_drive_file, color: textColor),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.attachmentName!,
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600)),
                          Text(m.attachmentSize ?? '',
                              style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 11)),
                        ],
                      ),
                    ],
                  )
                : Text(m.text,
                    style: TextStyle(color: textColor, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (m.reactions > 0) ...[
                  Text('${m.reactionEmoji ?? '\uD83D\uDC4D'} ${m.reactions}',
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                ],
                Text(m.time,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _composer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              decoration:
                  const InputDecoration(hintText: 'Type a message...'),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                  color: AppColors.emerald, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: AppColors.onEmerald),
            ),
          ),
        ],
      ),
    );
  }
}
