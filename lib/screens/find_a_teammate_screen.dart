import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class FindATeammateScreen extends StatefulWidget {
  const FindATeammateScreen({super.key});

  @override
  State<FindATeammateScreen> createState() => _FindATeammateScreenState();
}

class _FindATeammateScreenState extends State<FindATeammateScreen> {
  String _searchQuery = '';
  Set<String> _selectedSkills = {};

  static const List<String> _allSkills = [
    'Flutter',
    'React',
    'Python',
    'UI/UX Design',
    'Backend APIs',
    'Data Science',
    'Business Strategy',
    'Marketing',
    'Product Management',
    'AI/ML',
    'Finance',
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    var teammates = state.teammates;

    // Filter teammates based on search and skills
    if (_searchQuery.isNotEmpty) {
      teammates = teammates
          .where((t) =>
              t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.major.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedSkills.isNotEmpty) {
      teammates = teammates
          .where((t) => t.skills.any((skill) => _selectedSkills
              .any((s) => skill.toLowerCase().contains(s.toLowerCase()))))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Find a Teammate'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search box
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  hintText: 'Search teammates...',
                  prefixIcon:
                      Icon(Icons.search, color: AppColors.textSecondary),
                ),
              ),
            ),
            // Skills filter chips
            SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _allSkills.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final skill = _allSkills[i];
                  final isSelected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                    backgroundColor: AppColors.surfaceAlt,
                    selectedColor: AppColors.emerald.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.emerald
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.emerald : AppColors.border,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Teammates list
            Expanded(
              child: teammates.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search,
                              size: 64,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          const Text('No teammates found',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: teammates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _TeammateCard(teammate: teammates[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeammateCard extends StatelessWidget {
  final Teammate teammate;
  const _TeammateCard({required this.teammate});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, name, campus
          Row(
            children: [
              Avatar(name: teammate.name, color: teammate.color, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teammate.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(teammate.major,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(teammate.campus,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Connect button
              _ConnectButton(teammate: teammate),
            ],
          ),
          if (teammate.bio.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(teammate.bio,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
          // Skills
          if (teammate.skills.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Skills',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: teammate.skills
                  .map((skill) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: teammate.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(skill,
                            style: TextStyle(
                              color: teammate.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            )),
                      ))
                  .toList(),
            ),
          ],
          // Interests
          if (teammate.interests.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Interests',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: teammate.interests
                  .map((interest) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(interest,
                            style: const TextStyle(
                              color: AppColors.emerald,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            )),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConnectButton extends StatelessWidget {
  final Teammate teammate;
  const _ConnectButton({required this.teammate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppState>().toggleConnect(teammate.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(teammate.connected
                ? 'Connected with ${teammate.name}! 🎉'
                : 'Removed ${teammate.name}'),
            duration: const Duration(milliseconds: 1500),
            backgroundColor: teammate.connected
                ? AppColors.emerald
                : AppColors.textSecondary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      child: Consumer<AppState>(
        builder: (context, state, _) {
          final isConnected = state.isConnected(teammate.id);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppColors.emerald.withValues(alpha: 0.15)
                  : AppColors.emerald,
              border: Border.all(
                  color: isConnected ? AppColors.emerald : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isConnected ? Icons.check : Icons.add,
              color: isConnected ? AppColors.emerald : Colors.white,
              size: 18,
            ),
          );
        },
      ),
    );
  }
}
