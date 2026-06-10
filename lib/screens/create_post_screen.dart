import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  PostType _type = PostType.event;
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _date = TextEditingController();
  String _location = 'Kigali Campus';
  String? _category;
  String? _error;

  static const _locations = [
    'Kigali Campus',
    'Mauritius Campus',
    'All Campuses'
  ];
  static const _categories = [
    'Tech',
    'Workshop',
    'Startup',
    'Community',
    'Competition',
    'Internship',
    'Leadership'
  ];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (!mounted) return;
    final dateStr = '${_months[d.month - 1]} ${d.day}, ${d.year}';
    setState(() {
      _date.text =
          t == null ? dateStr : '$dateStr \u2022 ${t.format(context)}';
      _error = null;
    });
  }

  void _publish() {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Please add a title.');
      return;
    }
    if (_category == null) {
      setState(() => _error = 'Please select a category.');
      return;
    }
    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final gradient = _type == PostType.event
        ? const [AppColors.purple, AppColors.blue]
        : const [AppColors.green, AppColors.blue];

    state.addPost(Post(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      type: _type,
      title: _title.text.trim(),
      description: _desc.text.trim().isEmpty
          ? 'No description provided.'
          : _desc.text.trim(),
      organizer: state.currentUser.name,
      dateLabel: _date.text.trim().isEmpty ? 'Date TBA' : _date.text.trim(),
      location: _location,
      category: _category!,
      tags: [_category!],
      coverGradient: gradient,
      deadlineLabel: _type == PostType.opportunity
          ? (_date.text.trim().isEmpty ? 'Apply soon' : _date.text.trim())
          : null,
    ));

    navigator.pop();
    messenger.showSnackBar(const SnackBar(
      content: Text('Posted! It now appears in your feed.'),
      backgroundColor: AppColors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(leading: const BackButton(), title: const Text('Create Post')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            SegmentedToggle(
              leftLabel: 'Event',
              rightLabel: 'Opportunity',
              leftSelected: _type == PostType.event,
              onChanged: (left) => setState(() =>
                  _type = left ? PostType.event : PostType.opportunity),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Image upload is mocked in this prototype.')),
              ),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined,
                        color: AppColors.textSecondary, size: 32),
                    SizedBox(height: 8),
                    Text('Add cover image',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _label('Title'),
            TextField(
                controller: _title,
                decoration: const InputDecoration(
                    hintText: 'e.g. Leadership Workshop')),
            const SizedBox(height: 16),
            _label('Description'),
            TextField(
                controller: _desc,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: 'Tell people more about this...')),
            const SizedBox(height: 16),
            _label('Date & Time'),
            TextField(
              controller: _date,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                hintText: 'Select date & time',
                suffixIcon: Icon(Icons.calendar_today,
                    color: AppColors.textSecondary, size: 18),
              ),
            ),
            const SizedBox(height: 16),
            _label('Location'),
            _dropdown(_location, _locations,
                (v) => setState(() => _location = v ?? _location)),
            const SizedBox(height: 16),
            _label('Category'),
            _dropdown(_category, _categories,
                (v) => setState(() => _category = v),
                hint: 'Select category'),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.pink)),
            ],
            const SizedBox(height: 24),
            GoldButton(label: 'Publish', icon: Icons.send, onTap: _publish),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  Widget _dropdown(String? value, List<String> items,
      ValueChanged<String?> onChanged,
      {String? hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surfaceAlt,
          hint: hint != null
              ? Text(hint,
                  style: const TextStyle(color: AppColors.textSecondary))
              : null,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.textSecondary),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
