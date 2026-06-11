import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/cards.dart';
import 'communities_screen.dart';
import 'explore_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final featured = state.featured;
    final opportunities = state.opportunities;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, ${user.name.split(' ').first}! \uD83D\uDC4B',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      const Text("What's happening today?",
                          style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Avatar(name: user.name, color: user.color, size: 46),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              readOnly: true,
              onTap: () => _goExplore(context),
              decoration: const InputDecoration(
                hintText: 'Search opportunities, events, people...',
                prefixIcon:
                    Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 18),
            const _CategoryRow(),
            const SizedBox(height: 22),
            SectionHeader(
                title: 'Featured', onSeeAll: () => _goExplore(context)),
            const SizedBox(height: 12),
            ...featured.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: FeaturedCard(post: p),
                )),
            const SizedBox(height: 8),
            SectionHeader(
                title: 'Latest Opportunities',
                onSeeAll: () => _goExplore(context)),
            const SizedBox(height: 12),
            if (opportunities.isEmpty)
              const EmptyState(
                  icon: Icons.inbox,
                  message: 'No opportunities yet. Be the first to post one!')
            else
              ...opportunities.map((p) => OpportunityRow(post: p)),
          ],
        ),
      ),
    );
  }

  void _goExplore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExploreScreen(standalone: true)),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    const cats = [
      _Cat('All', Icons.grid_view_rounded, AppColors.emerald),
      _Cat('Events', Icons.event, AppColors.purple),
      _Cat('Opportunities', Icons.verified, AppColors.blue),
      _Cat('Clubs', Icons.diversity_3, AppColors.green),
      _Cat('Academics', Icons.school, AppColors.pink),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cats.map((c) => _CategoryButton(cat: c)).toList(),
    );
  }
}

class _Cat {
  final String label;
  final IconData icon;
  final Color color;
  const _Cat(this.label, this.icon, this.color);
}

class _CategoryButton extends StatelessWidget {
  final _Cat cat;
  const _CategoryButton({required this.cat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cat.label == 'Clubs') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CommunitiesScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ExploreScreen(standalone: true, initialFilter: cat.label),
            ),
          );
        }
      },
      child: SizedBox(
        width: 62,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(cat.icon, color: cat.color),
            ),
            const SizedBox(height: 6),
            Text(cat.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
