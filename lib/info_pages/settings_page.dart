import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool notificationsEnabled;
  final int selectedThemeIndex;
  final Function(bool) onToggleNotifications;
  final void Function(int?)? onChangeTheme;
  final List<String> themeNames;

  const SettingsPage({
    Key? key,
    required this.notificationsEnabled,
    required this.selectedThemeIndex,
    required this.onToggleNotifications,
    required this.onChangeTheme,
    required this.themeNames,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
