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
      appBar:
          AppBar(leading: const BackButton(), title: const Text('My RSVPs')),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              SegmentedToggle(
                leftLabel: 'Going',
                rightLabel: 'Interested',
                leftSelected: _going,
                onChanged: (left) => setState(() => _going = left),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: list.isEmpty
                    ? EmptyState(
                        icon: Icons.event_busy,
                        message: _going
                            ? "You haven't RSVP'd to anything yet."
                            : 'No saved events yet.')
                    : ListView(
                        children: list
                            .map((p) => EventListCard(
                                  post: p,
                                  statusLabel:
                                      _going ? 'Going' : 'Interested',
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
    );
  }
}
