import 'package:flutter/material.dart';

import '../setting_settings_bar.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({Key? key}) : super(key: key);

  @override
  _AppearanceSettingsScreenState createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  AppTheme selectedTheme = AppTheme.light;
  FontSize selectedFontSize = FontSize.medium;
  Language selectedLanguage = Language.english;
  bool _hasChanges = false;

  void _selectTheme(AppTheme? theme) {
    if (theme != null) {
      setState(() {
        selectedTheme = theme;
        _hasChanges = true;
        // TODO: change the theme globally!
      });
    }
  }

  void _selectFontSize(FontSize? fontSize) {
    if (fontSize != null) {
      setState(() {
        selectedFontSize = fontSize;
        _hasChanges = true;
      });
    }
  }

  void _selectLanguage(Language? language) {
    if (language != null) {
      setState(() {
        selectedLanguage = language;
        _hasChanges = true;
      });
    }
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
        title: const Text('Appearance Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Theme'),
            subtitle: const Text('Choose the theme for the app'),
            trailing: DropdownButton<AppTheme>(
              value: selectedTheme,
              onChanged: _selectTheme,
              items: AppTheme.values.map((theme) {
                return DropdownMenuItem<AppTheme>(
                  value: theme,
                  child: Text(theme.displayName),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Font Size'),
            subtitle: const Text('Adjust the font size'),
            trailing: DropdownButton<FontSize>(
              value: selectedFontSize,
              onChanged: _selectFontSize,
              items: FontSize.values.map((fontSize) {
                return DropdownMenuItem<FontSize>(
                  value: fontSize,
                  child: Text(fontSize.displayName),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('Choose the app language'),
            trailing: DropdownButton<Language>(
              value: selectedLanguage,
              onChanged: _selectLanguage,
              items: Language.values.map((language) {
                return DropdownMenuItem<Language>(
                  value: language,
                  child: Text(language.displayName),
                );
              }).toList(),
            ),
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

enum AppTheme {
  light,
  dark,
}

extension AppThemeExtension on AppTheme {
  String get displayName {
    switch (this) {
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
    }
  }
}

enum FontSize {
  small,
  medium,
  large,
  extraLarge,
}

extension FontSizeExtension on FontSize {
  String get displayName {
    switch (this) {
      case FontSize.small:
        return 'S';
      case FontSize.medium:
        return 'M';
      case FontSize.large:
        return 'L';
      case FontSize.extraLarge:
        return 'XL';
    }
  }
}

enum Language {
  english,
  german,
}

extension LanguageExtension on Language {
  String get displayName {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.german:
        return 'German';
    }
  }
}
