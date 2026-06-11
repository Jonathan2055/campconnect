import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class CreateFeedPostScreen extends StatefulWidget {
  const CreateFeedPostScreen({super.key});

  @override
  State<CreateFeedPostScreen> createState() => _CreateFeedPostScreenState();
}

class _CreateFeedPostScreenState extends State<CreateFeedPostScreen> {
  final _contentController = TextEditingController();
  FeedEntryType _type = FeedEntryType.experience;
  Post? _selectedEvent;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _contentController.text.trim().isNotEmpty;

  void _submit() {
    final state = context.read<AppState>();
    final user = state.currentUser;
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    state.addFeedEntry(FeedEntry(
      id: 'f${DateTime.now().millisecondsSinceEpoch}',
      authorName: user.name,
      authorColor: user.color,
      content: content,
      type: _type,
      timeAgo: 'Just now',
      linkedEventId: _selectedEvent?.id,
      linkedEventTitle: _selectedEvent?.title,
      linkedEventDate: _selectedEvent?.dateLabel,
      linkedEventLocation: _selectedEvent?.location,
      linkedEventGradient: _selectedEvent?.coverGradient,
    ));

    Navigator.pop(context);
  }

  Future<void> _pickEvent(List<Post> posts) async {
    final picked = await showModalBottomSheet<Post>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EventPickerSheet(posts: posts, selected: _selectedEvent),
    );
    if (picked != null) setState(() => _selectedEvent = picked);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        leadingWidth: 80,
        title: const Text('Share on Feed'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ListenableBuilder(
              listenable: _contentController,
              builder: (ctx, _) => FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      _canSubmit ? AppColors.emerald : AppColors.border,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                  minimumSize: const Size(64, 36),
                ),
                onPressed: _canSubmit ? _submit : null,
                child: const Text('Post',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: AppColors.border),
          // Type selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _TypeChip(
                  label: 'Experience',
                  icon: Icons.star_outline_rounded,
                  selected: _type == FeedEntryType.experience,
                  color: AppColors.emerald,
                  onTap: () => setState(() {
                    _type = FeedEntryType.experience;
                    _selectedEvent = null;
                  }),
                ),
                const SizedBox(width: 10),
                _TypeChip(
                  label: 'Promote Event',
                  icon: Icons.campaign_outlined,
                  selected: _type == FeedEntryType.promotion,
                  color: AppColors.purple,
                  onTap: () => setState(() => _type = FeedEntryType.promotion),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Author row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Avatar(name: user.name, color: user.color, size: 40),
                const SizedBox(width: 10),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Content field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                autofocus: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: _type == FeedEntryType.experience
                      ? 'Share your experience at an event…'
                      : 'Tell people about this event…',
                  hintStyle: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 15),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
                style: const TextStyle(
                    fontSize: 15, color: AppColors.textPrimary, height: 1.5),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          // Selected event preview
          if (_selectedEvent != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: _SelectedEventPreview(
                post: _selectedEvent!,
                onRemove: () => setState(() => _selectedEvent = null),
              ),
            ),
          // Bottom toolbar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                if (_type == FeedEntryType.promotion)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.purple),
                    icon: const Icon(Icons.event_outlined, size: 18),
                    label: Text(_selectedEvent == null
                        ? 'Tag an Event'
                        : 'Change Event'),
                    onPressed: () => _pickEvent(state.posts),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: selected ? color : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedEventPreview extends StatelessWidget {
  final Post post;
  final VoidCallback onRemove;

  const _SelectedEventPreview(
      {required this.post, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: post.coverGradient,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        post.dateLabel,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.textSecondary,
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventPickerSheet extends StatefulWidget {
  final List<Post> posts;
  final Post? selected;

  const _EventPickerSheet({required this.posts, this.selected});

  @override
  State<_EventPickerSheet> createState() => _EventPickerSheetState();
}

class _EventPickerSheetState extends State<_EventPickerSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.posts
        .where((p) =>
            p.title.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (ctx, scrollController) => Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search events & opportunities…',
                prefixIcon: Icon(Icons.search_rounded),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final post = filtered[i];
                final isSelected = widget.selected?.id == post.id;
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: post.coverGradient),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.event_rounded,
                        color: Colors.white, size: 20),
                  ),
                  title: Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    post.dateLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.emerald)
                      : null,
                  onTap: () => Navigator.pop(context, post),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
