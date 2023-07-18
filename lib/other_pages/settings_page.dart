import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool notificationsEnabled;
  late int selectedThemeIndex;
  late Function(bool) onToggleNotifications;
  late void Function(int?)? onChangeTheme;
  late List<String> themeNames;


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
            value: notificationsEnabled,
            onChanged: onToggleNotifications,
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(themeNames[selectedThemeIndex]),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Select Theme'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(
                      themeNames.length,
                      (index) => RadioListTile(
                        title: Text(themeNames[index]),
                        value: index,
                        groupValue: selectedThemeIndex,
                        onChanged: onChangeTheme,
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
