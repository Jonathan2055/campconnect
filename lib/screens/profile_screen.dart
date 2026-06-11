import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'my_rsvps_screen.dart';
import 'communities_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Profile',
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800)),
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.textSecondary),
                  onPressed: () => _editProfile(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Avatar(name: user.name, color: user.color, size: 92),
                  const SizedBox(height: 12),
                  Text(user.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  Text(user.campus,
                      style:
                          const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _stat('${user.events}', 'Events'),
                _stat('${user.communities}', 'Communities'),
                _stat('${user.connections}', 'Connections'),
              ],
            ),
            const SizedBox(height: 24),
            _tile(context, Icons.event_available, 'My RSVPs',
                () => _push(context, const MyRsvpsScreen())),
            _tile(context, Icons.groups, 'My Communities',
                () => _push(context, const CommunitiesScreen())),
            _tile(context, Icons.bookmark_border, 'Saved',
                () => _soon(context)),
            _tile(context, Icons.notifications_none, 'Notifications',
                () => _soon(context)),
            _tile(context, Icons.settings_outlined, 'Account Settings',
                () => _editProfile(context)),
            _tile(context, Icons.help_outline, 'Help & Support',
                () => _soon(context)),
            const SizedBox(height: 12),
            OutlineButton2(
                label: 'Log Out',
                color: AppColors.pink,
                onTap: state.logout),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.emerald)),
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label,
      VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: AppColors.emerald),
          title: Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right,
              color: AppColors.textSecondary),
          onTap: onTap,
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    final state = context.read<AppState>();
    final nameCtrl = TextEditingController(text: state.currentUser.name);
    const campuses = ['Kigali Campus', 'Mauritius Campus', 'Lagos Campus'];
    String campus = campuses.contains(state.currentUser.campus)
        ? state.currentUser.campus
        : campuses.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setModal) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 24, 24,
                  MediaQuery.of(sheetCtx).viewInsets.bottom + 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Profile',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  const Text('Name',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        hintText: 'Your full name'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Campus',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: campus,
                        isExpanded: true,
                        dropdownColor: AppColors.surfaceAlt,
                        onChanged: (v) =>
                            setModal(() => campus = v ?? campus),
                        items: campuses
                            .map((c) => DropdownMenuItem(
                                value: c, child: Text(c)))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald,
                        foregroundColor: AppColors.onEmerald,
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        context
                            .read<AppState>()
                            .updateProfile(name, campus);
                        Navigator.pop(sheetCtx);
                      },
                      child: const Text('Save Changes',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon in the full version.')),
    );
  }
}
