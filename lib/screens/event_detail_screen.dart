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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      GradientCover(
                        colors: post.coverGradient,
                        height: 220,
                        radius: BorderRadius.zero,
                        icon: isOpportunity
                            ? Icons.workspace_premium
                            : Icons.celebration,
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black26,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('by ${post.organizer}',
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: post.tags
                              .map((t) => PillTag(
                                  label: t, color: categoryColor(t)))
                              .toList(),
                        ),
                        const SizedBox(height: 18),
                        _infoRow(Icons.calendar_today, post.dateLabel),
                        const SizedBox(height: 12),
                        _infoRow(Icons.location_on, post.location),
                        const SizedBox(height: 18),
                        Text('About',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(post.description,
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                height: 1.5,
                                fontSize: 15)),
                        const SizedBox(height: 20),
                        if (!isOpportunity)
                          Row(children: [
                            const Icon(Icons.group,
                                size: 18, color: AppColors.emerald),
                            const SizedBox(width: 8),
                            Text(
                                '${state.displayedGoing(post)} going  \u2022  ${state.displayedInterested(post)} interested',
                                style: const TextStyle(
                                    color: AppColors.textSecondary)),
                          ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(color: AppColors.surface),
              child: isOpportunity
                  ? GoldButton(
                      label: going ? 'Registered \u2713' : 'Apply / Register',
                      icon: Icons.open_in_new,
                      onTap: () => _register(context, state),
                    )
                  : Column(
                      children: [
                        GoldButton(
                          label: going ? "You're Going \u2713" : 'RSVP',
                          onTap: () => state.toggleGoing(post.id),
                        ),
                        const SizedBox(height: 10),
                        OutlineButton2(
                          label: interested
                              ? 'Interested \u2713'
                              : 'Interested',
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

  Widget _infoRow(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.emerald),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
    ]);
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
