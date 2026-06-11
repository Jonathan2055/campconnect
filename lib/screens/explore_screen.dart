import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/cards.dart';

class ExploreScreen extends StatefulWidget {
  /// When true, the screen is pushed (shows a back button + AppBar) rather
  /// than living inside the bottom-nav shell.
  final bool standalone;
  final String? initialFilter;
  const ExploreScreen(
      {super.key, this.standalone = false, this.initialFilter});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late String _filter = widget.initialFilter ?? 'All';
  String _query = '';
  static const _filters = ['All', 'Events', 'Opportunities', 'Clubs'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: widget.standalone
          ? AppBar(leading: const BackButton(), title: const Text('Explore'))
          : null,
      body: SafeArea(
        top: !widget.standalone,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            if (!widget.standalone) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Explore',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w800)),
                  Icon(Icons.notifications_none_rounded,
                      color: AppColors.emerald),
                ],
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon:
                    Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final f = _filters[i];
                  final active = f == _filter;
                  return ChoiceChip(
                    label: Text(f),
                    selected: active,
                    onSelected: (_) => setState(() => _filter = f),
                    backgroundColor: AppColors.surfaceAlt,
                    selectedColor: AppColors.emerald,
                    labelStyle: TextStyle(
                        color: active
                            ? AppColors.onEmerald
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppColors.border)),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            const Text('Recommended for you',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ..._buildResults(state),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResults(AppState state) {
    if (_filter == 'Clubs') {
      final clubs = state.communities
          .where((c) =>
              c.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();
      if (clubs.isEmpty) {
        return [
          const EmptyState(
              icon: Icons.groups, message: 'No clubs match your search.')
        ];
      }
      return clubs.map((c) => CommunityTile(community: c)).toList();
    }

    List<Post> items;
    if (_filter == 'Events') {
      items = state.events;
    } else if (_filter == 'Opportunities') {
      items = state.opportunities;
    } else {
      items = state.posts;
    }
    if (_query.isNotEmpty) {
      items = items
          .where((p) =>
              p.title.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    if (items.isEmpty) {
      return [
        const EmptyState(
            icon: Icons.search_off,
            message: 'Nothing found. Try a different search or filter.')
      ];
    }
    return items.map((p) => OpportunityRow(post: p)).toList();
  }
}
