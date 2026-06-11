import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'find_a_teammate_screen.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  String _searchQuery = '';
  bool _showJoined = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allCommunities = state.communities;

    // Filter based on joined status and search query
    final filteredCommunities = allCommunities.where((c) {
      final matchesSearch = _searchQuery.isEmpty ||
          c.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _showJoined ? c.joined : true;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Communities',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FindATeammateScreen(),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.emerald,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person_add,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: const InputDecoration(
                      hintText: 'Search communities...',
                      prefixIcon:
                          Icon(Icons.search, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: SegmentedToggle(
                            leftLabel: 'All',
                            rightLabel: 'My Communities',
                            leftSelected: !_showJoined,
                            onChanged: (left) =>
                                setState(() => _showJoined = !left),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredCommunities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.diversity_3,
                              size: 64,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          const Text('No communities found',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: filteredCommunities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final community = filteredCommunities[i];
                        return _CommunityCard(community: community);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final Community community;
  const _CommunityCard({required this.community});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          // Community avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: community.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: community.color, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.diversity_3, color: community.color, size: 24),
          ),
          const SizedBox(width: 12),
          // Community info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(community.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${community.members} members',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Join button
          _JoinButton(community: community),
        ],
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  final Community community;
  const _JoinButton({required this.community});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppState>().toggleJoin(community.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(community.joined
                ? 'Left ${community.name}'
                : 'Joined ${community.name}!'),
            duration: const Duration(milliseconds: 1500),
            backgroundColor:
                community.joined ? AppColors.textSecondary : AppColors.emerald,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      child: Consumer<AppState>(
        builder: (context, state, _) {
          final isJoined =
              state.communities.firstWhere((c) => c.id == community.id).joined;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isJoined
                  ? AppColors.emerald.withValues(alpha: 0.1)
                  : AppColors.emerald,
              border: Border.all(
                  color: isJoined ? AppColors.emerald : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isJoined ? 'Joined' : 'Join',
              style: TextStyle(
                color: isJoined ? AppColors.emerald : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          );
        },
      ),
    );
  }
}
