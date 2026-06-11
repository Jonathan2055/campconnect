import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/cards.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  bool _all = true;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final list = _all ? state.communities : state.myCommunities;

    return Scaffold(
      appBar:
          AppBar(leading: const BackButton(), title: const Text('Communities')),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              SegmentedToggle(
                leftLabel: 'All Clubs',
                rightLabel: 'My Clubs',
                leftSelected: _all,
                onChanged: (left) => setState(() => _all = left),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: list.isEmpty
                    ? const EmptyState(
                        icon: Icons.groups,
                        message: "You haven't joined any clubs yet.")
                    : ListView(
                        children: list
                            .map((c) => CommunityTile(community: c))
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
