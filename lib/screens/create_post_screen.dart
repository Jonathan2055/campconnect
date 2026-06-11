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
  // 0 = event, 1 = opportunity, 2 = club
  int _mode = 0;
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _date = TextEditingController();
  String _location = 'Kigali Campus';
  String? _category;
  String? _error;

  static const _locations = [
    'Kigali Campus',
    'Mauritius Campus',
    'All Campuses',
  ];
  static const _categories = [
    'Tech',
    'Workshop',
    'Startup',
    'Community',
    'Competition',
    'Internship',
    'Leadership',
  ];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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
          t == null ? dateStr : '$dateStr • ${t.format(context)}';
      _error = null;
    });
  }

  void _publish() {
    final titleText = _title.text.trim();
    if (titleText.isEmpty) {
      setState(() =>
          _error = _mode == 2 ? 'Please add a club name.' : 'Please add a title.');
      return;
    }
    if (_category == null) {
      setState(() => _error = 'Please select a category.');
      return;
    }

    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_mode == 2) {
      const clubColors = [
        AppColors.emerald, AppColors.purple, AppColors.blue,
        AppColors.teal, AppColors.pink, AppColors.green,
      ];
      state.addCommunity(Community(
        id: 'club${DateTime.now().millisecondsSinceEpoch}',
        name: titleText,
        members: 1,
        color: clubColors[titleText.length % clubColors.length],
        joined: true,
      ));
      navigator.pop();
      messenger.showSnackBar(const SnackBar(
        content: Text('Club created! Find it in Communities.'),
        backgroundColor: AppColors.green,
      ));
      return;
    }

    final isOpportunity = _mode == 1;
    state.addPost(Post(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      type: isOpportunity ? PostType.opportunity : PostType.event,
      title: titleText,
      description: _desc.text.trim().isEmpty
          ? 'No description provided.'
          : _desc.text.trim(),
      organizer: state.currentUser.name,
      dateLabel:
          _date.text.trim().isEmpty ? 'Date TBA' : _date.text.trim(),
      location: _location,
      category: _category!,
      tags: [_category!],
      coverGradient: isOpportunity
          ? const [AppColors.green, AppColors.blue]
          : const [AppColors.purple, AppColors.blue],
      deadlineLabel: isOpportunity
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
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_mode == 2 ? 'Create Club' : 'Create Post'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _modeBtn('Event', 0),
                  _modeBtn('Opportunity', 1),
                  _modeBtn('Club', 2),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_mode != 2) ...[
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Image upload is mocked in this prototype.')),
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
                          style:
                              TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
            _label(_mode == 2 ? 'Club Name' : 'Title'),
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: _mode == 2
                    ? 'e.g. Photography Club'
                    : 'e.g. Leadership Workshop',
              ),
            ),
            const SizedBox(height: 16),
            _label(_mode == 2 ? 'About this club' : 'Description'),
            TextField(
              controller: _desc,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _mode == 2
                    ? 'What is this club about?'
                    : 'Tell people more about this...',
              ),
            ),
            const SizedBox(height: 16),
            if (_mode != 2) ...[
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
            ],
            _label('Category'),
            _dropdown(_category, _categories,
                (v) => setState(() => _category = v),
                hint: 'Select category'),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!,
                  style: const TextStyle(color: AppColors.pink)),
            ],
            const SizedBox(height: 24),
            GoldButton(
              label: _mode == 2 ? 'Create Club' : 'Publish',
              icon: _mode == 2 ? Icons.group_add : Icons.send,
              onTap: _publish,
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeBtn(String label, int mode) {
    final active = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _mode = mode;
          _error = null;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.emerald : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color:
                  active ? AppColors.onEmerald : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child:
            Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  Widget _dropdown(
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    String? hint,
  }) {
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
                  style:
                      const TextStyle(color: AppColors.textSecondary))
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
