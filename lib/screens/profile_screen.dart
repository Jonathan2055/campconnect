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
              children: const [
                Text('Profile',
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800)),
                Icon(Icons.settings, color: AppColors.textSecondary),
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
                () => _soon(context)),
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
      child: ListTile(
        leading: Icon(icon, color: AppColors.emerald),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon in the full version.')),
    );
  }
}
