import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/cards.dart';

class MyRsvpsScreen extends StatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen> {
  bool _going = true;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final list = _going ? state.goingPosts : state.interestedPosts;

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Dark header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'My RSVPs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: SegmentedToggle(
                          leftLabel: 'Going',
                          rightLabel: 'Interested',
                          leftSelected: _going,
                          onChanged: (left) =>
                              setState(() => _going = left),
                        ),
                      ),
                      Expanded(
                        child: list.isEmpty
                            ? EmptyState(
                                icon: Icons.event_busy_rounded,
                                message: _going
                                    ? "You haven't RSVP'd to anything yet."
                                    : 'No saved events yet.',
                              )
                            : ListView(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 100),
                                children: list
                                    .map((p) => EventListCard(
                                          post: p,
                                          statusLabel: _going
                                              ? 'Going'
                                              : 'Interested',
                                          statusColor: _going
                                              ? AppColors.green
                                              : AppColors.emerald,
                                        ))
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
