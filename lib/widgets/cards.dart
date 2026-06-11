import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../screens/event_detail_screen.dart';
import '../screens/chat_detail_screen.dart';
import 'common.dart';

void openPost(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => EventDetailScreen(post: post)),
  );
}

/// Large highlighted card for the Featured carousel/section.
class FeaturedCard extends StatelessWidget {
  final Post post;
  const FeaturedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openPost(context, post),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GradientCover(
                  colors: post.coverGradient,
                  height: 120,
                  radius: BorderRadius.zero,
                  icon: Icons.celebration,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.surface.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.organizer,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(post.title,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: AppColors.emerald),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(post.dateLabel,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 160,
                    child: GoldButton(
                        label: 'View details',
                        onTap: () => openPost(context, post)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact horizontal row for opportunities / search results.
class OpportunityRow extends StatelessWidget {
  final Post post;
  const OpportunityRow({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openPost(context, post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GradientCover(
                colors: post.coverGradient,
                width: 56,
                height: 56,
                radius: BorderRadius.zero,
                icon: post.type == PostType.opportunity
                    ? Icons.workspace_premium
                    : Icons.event,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(post.deadlineLabel ?? post.dateLabel,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(post.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PillTag(label: post.category, color: categoryColor(post.category)),
          ],
        ),
      ),
    );
  }
}

/// Card with a status pill, used in My RSVPs.
class EventListCard extends StatelessWidget {
  final Post post;
  final String? statusLabel;
  final Color? statusColor;
  const EventListCard(
      {super.key, required this.post, this.statusLabel, this.statusColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openPost(context, post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GradientCover(
                colors: post.coverGradient,
                width: 70,
                height: 70,
                radius: BorderRadius.zero,
                icon: Icons.event,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(post.dateLabel,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  if (statusLabel != null)
                    PillTag(
                        label: statusLabel!,
                        color: statusColor ?? AppColors.emerald),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A community row with a Join / Joined toggle wired to state.
class CommunityTile extends StatelessWidget {
  final Community community;
  const CommunityTile({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final joined = community.joined;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Avatar(name: community.name, color: community.color, size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(community.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 3),
                Text('${community.members} members',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: joined ? AppColors.green : AppColors.emerald,
              side: BorderSide(
                  color: joined ? AppColors.green : AppColors.emerald),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => state.toggleJoin(community.id),
            child: Text(joined ? 'Joined' : 'Join'),
          ),
        ],
      ),
    );
  }
}

/// A chat list row; tapping marks it read and opens the thread.
class ChatTile extends StatelessWidget {
  final ChatThread thread;
  const ChatTile({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppState>().markRead(thread.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatDetailScreen(thread: thread)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Avatar(name: thread.name, color: thread.color, size: 50),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(thread.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                      Text(thread.time,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(thread.lastMessagePreview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                      ),
                      if (thread.unread > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(
                              minWidth: 22, minHeight: 22),
                          decoration: const BoxDecoration(
                              color: AppColors.emerald, shape: BoxShape.circle),
                          child: Text('${thread.unread}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColors.onEmerald,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
