import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool notificationsEnabled = true;
  final int selectedThemeIndex = 0;
  final List<String> themeNames = const ['Light', 'Dark', 'System'];

  void onToggleNotifications(bool isActiveNotifications) {
    print("Notification are toggled on: $isActiveNotifications");
  }

  void onChangeTheme(int? themeIndex) {
    print("Theme was changed to: $themeIndex");
  }

  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            value: widget.notificationsEnabled,
            onChanged: widget.onToggleNotifications,
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(widget.themeNames[widget.selectedThemeIndex]),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Select Theme'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(
                      widget.themeNames.length,
                      (index) => RadioListTile(
                        title: Text(widget.themeNames[index]),
                        value: index,
                        groupValue: widget.selectedThemeIndex,
                        onChanged: widget.onChangeTheme,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Font Size'),
            subtitle: const Text('Medium'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
