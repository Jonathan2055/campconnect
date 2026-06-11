import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/cards.dart';

class ExploreScreen extends StatefulWidget {
  final bool standalone;
  final String? initialFilter;
  const ExploreScreen({super.key, this.standalone = false, this.initialFilter});

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
      backgroundColor: AppColors.dark,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Dark header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Row(
                children: [
                  if (widget.standalone) ...[
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
                  ],
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Discover events, clubs & more',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            // ── White rounded body ───────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    children: [
                      // Search
                      TextField(
                        onChanged: (v) => setState(() => _query = v),
                        decoration: const InputDecoration(
                          hintText: 'Search events, opportunities…',
                          prefixIcon: Icon(Icons.search,
                              color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Filter chips
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final f = _filters[i];
                            final active = f == _filter;
                            return ChoiceChip(
                              label: Text(f),
                              selected: active,
                              onSelected: (_) => setState(() => _filter = f),
                              backgroundColor: AppColors.surface,
                              selectedColor: AppColors.emerald,
                              labelStyle: TextStyle(
                                color: active
                                    ? AppColors.onEmerald
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: active
                                      ? AppColors.emerald
                                      : AppColors.border,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Recommended for you',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      ..._buildResults(state),
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

  List<Widget> _buildResults(AppState state) {
    if (_filter == 'Clubs') {
      final clubs = state.communities
          .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
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
          .where((p) => p.title.toLowerCase().contains(_query.toLowerCase()))
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
