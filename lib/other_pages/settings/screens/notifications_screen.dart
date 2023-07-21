import 'package:flutter/material.dart';

import '../setting_settings_bar.dart';

/// todo
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  _NotificationsSettingsScreenState createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool pushNotificationsEnabled = true;
  bool emailNotificationsEnabled = true;
  bool immediateNotificationsEnabled = true;
  bool _hasChanges = false;

  void _saveSettings() {
    // Save the selected settings
  }

  void _cancelSettings() {
    // Discard the changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: pushNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                pushNotificationsEnabled = value;
                _hasChanges = true;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            value: emailNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                emailNotificationsEnabled = value;
                _hasChanges = true;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: SettingsBottomBar(
        hasChanges: _hasChanges,
        onSave: _saveSettings,
        onCancel: _cancelSettings,
      ),
    );
  }
}