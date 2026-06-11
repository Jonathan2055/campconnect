import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class EventDetailScreen extends StatelessWidget {
  final Post post;
  const EventDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final going = state.isGoing(post.id);
    final interested = state.isInterested(post.id);
    final isOpportunity = post.type == PostType.opportunity;

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Gradient hero header ─────────────────────────────
            SizedBox(
              height: 240,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: post.coverGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: 10,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Bottom fade to dark
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.dark.withValues(alpha: 0.6),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: 12,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  // Category badge top-right
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        post.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  // Center icon
                  Center(
                    child: Icon(
                      isOpportunity
                          ? Icons.workspace_premium_rounded
                          : Icons.celebration_rounded,
                      color: Colors.white.withValues(alpha: 0.25),
                      size: 80,
                    ),
                  ),
                ],
              ),
            ),
            // ── White rounded body ───────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    children: [
                      // Tags row
                      if (post.tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: post.tags
                              .map((t) => PillTag(
                                  label: t, color: categoryColor(t)))
                              .toList(),
                        ),
                      const SizedBox(height: 14),
                      // Title
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${post.organizer}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 18),
                      // Info cards
                      _infoCard(
                          Icons.calendar_today_rounded, post.dateLabel),
                      const SizedBox(height: 8),
                      _infoCard(
                          Icons.location_on_rounded, post.location),
                      const SizedBox(height: 20),
                      // About
                      const Text(
                        'About',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.description,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.6,
                          fontSize: 14.5,
                        ),
                      ),
                      if (!isOpportunity) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.emerald
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.emerald
                                    .withValues(alpha: 0.2)),
                          ),
                          child: Row(children: [
                            const Icon(Icons.group_rounded,
                                size: 18, color: AppColors.emerald),
                            const SizedBox(width: 10),
                            Text(
                              '${state.displayedGoing(post)} going  ·  ${state.displayedInterested(post)} interested',
                              style: const TextStyle(
                                color: AppColors.emerald,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // ── Action bar ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                    top: BorderSide(color: AppColors.border)),
              ),
              child: isOpportunity
                  ? GoldButton(
                      label: going ? 'Registered ✓' : 'Apply / Register',
                      icon: Icons.open_in_new,
                      onTap: () => _register(context, state),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GoldButton(
                          label: going ? "You're Going ✓" : 'RSVP — I\'m Going',
                          onTap: () => state.toggleGoing(post.id),
                        ),
                        const SizedBox(height: 10),
                        OutlineButton2(
                          label: interested ? 'Interested ✓' : 'Interested',
                          onTap: () => state.toggleInterested(post.id),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.emerald),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ]),
    );
  }

  void _register(BuildContext context, AppState state) {
    state.toggleGoing(post.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(state.isGoing(post.id)
          ? 'Registered! Check My RSVPs.'
          : 'Registration removed.'),
      backgroundColor: AppColors.green,
    ));
  }
}
