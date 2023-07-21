import 'package:flutter/material.dart';
import 'package:safe_streets/other_pages/settings/screens/account_settings.dart';
import 'package:safe_streets/other_pages/settings/screens/appearence_screen.dart';
import 'package:safe_streets/other_pages/settings/screens/help_support_screen.dart';
import 'package:safe_streets/other_pages/settings/screens/notifications_screen.dart';
import 'package:safe_streets/other_pages/settings/screens/privacy_security_screen.dart';

import '../../ui/bottom_menu/bottom_navigation_bar.dart';

/// todo
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            icon: Icons.account_circle,
            title: 'Account',
            onPressed: () {
              // Navigate to account settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsScreen(),
                ),
              );
            },
          ),
          _buildSection(
            icon: Icons.notifications,
            title: 'Notifications',
            onPressed: () {
              // Navigate to notifications settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsSettingsScreen(),
                ),
              );
            },
          ),
          _buildSection(
            icon: Icons.palette,
            title: 'Appearance',
            onPressed: () {
              // Navigate to appearance settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppearanceSettingsScreen(),
                ),
              );
            },
          ),
          _buildSection(
            icon: Icons.security,
            title: 'Privacy & Security',
            onPressed: () {
              // Navigate to privacy & security settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySecuritySettingsScreen(),
                ),
              );
            },
          ),
          _buildSection(
            icon: Icons.help,
            title: 'Help & Support',
            onPressed: () {
              // Navigate to help & support screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required VoidCallback onPressed}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onPressed,
    );
  }
}
