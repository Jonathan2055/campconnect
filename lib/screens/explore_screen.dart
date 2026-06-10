import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ExploreScreen extends StatefulWidget {
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
          ],
        ),
      ),
    );
  }
}