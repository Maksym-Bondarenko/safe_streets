import 'package:flutter/material.dart';
import 'package:safe_streets/other_pages/settings/setting_settings_bar.dart';

class PrivacySecuritySettingsScreen extends StatefulWidget {
  const PrivacySecuritySettingsScreen({super.key});

  @override
  _PrivacySecuritySettingsScreenState createState() =>
      _PrivacySecuritySettingsScreenState();
}

class _PrivacySecuritySettingsScreenState
    extends State<PrivacySecuritySettingsScreen> {
  bool isAccountPublic = true;
  bool isTwoFactorAuthEnabled = false;
  bool _hasChanges = false;

  void toggleAccountPrivacy() {
    setState(() {
      isAccountPublic = !isAccountPublic;
      _hasChanges = true;
    });
  }

  void toggleTwoFactorAuth() {
    setState(() {
      isTwoFactorAuthEnabled = !isTwoFactorAuthEnabled;
      _hasChanges = true;
    });
  }

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
        title: const Text('Privacy & Security Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Account Privacy'),
            subtitle: Text(isAccountPublic ? 'Public' : 'Private'),
            trailing: Icon(
              isAccountPublic ? Icons.lock_open : Icons.lock,
            ),
            onTap: toggleAccountPrivacy,
          ),
          ListTile(
            title: const Text('Two-Factor Authentication'),
            subtitle: Text(isTwoFactorAuthEnabled ? 'Enabled' : 'Disabled'),
            trailing: Icon(
              isTwoFactorAuthEnabled
                  ? Icons.check_circle
                  : Icons.radio_button_off,
            ),
            onTap: toggleTwoFactorAuth,
          ),
          ListTile(
            title: const Text('Password Management'),
            subtitle: const Text('Manage your passwords'),
            trailing: const Icon(Icons.vpn_key),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            subtitle: const Text('View the terms of service'),
            trailing: const Icon(Icons.description),
            onTap: () {
              Navigator.pushNamed(context, '/terms_and_conditions');
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('View the privacy policy'),
            trailing: const Icon(Icons.privacy_tip),
            onTap: () {
              Navigator.pushNamed(context, '/privacy_policy');
            },
          ),
          ListTile(
            title: const Text('Account Activity'),
            subtitle: const Text('View recent account activity'),
            trailing: const Icon(Icons.history),
            onTap: () {
              Navigator.pushNamed(context, '/account_activity');
            },
          ),
          ListTile(
            title: const Text('Third-Party Access'),
            subtitle: const Text('Manage third-party access to your account'),
            trailing: const Icon(Icons.security),
            onTap: () {
              // TODO: Implement managing third-party access
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
