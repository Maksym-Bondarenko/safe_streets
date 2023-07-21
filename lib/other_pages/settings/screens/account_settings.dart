import 'package:flutter/material.dart';
import 'package:safe_streets/other_pages/settings/setting_settings_bar.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  Gender selectedGender = Gender.other;
  SubscriptionType selectedSubscription = SubscriptionType.basic;
  bool isSafe = false;

  bool _hasChanges = false;

  void _saveSettings() {
    // Save the selected settings
    _hasChanges = false;
  }

  void _cancelSettings() {
    // Discard the changes
    _hasChanges = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: ListView(
        children: [
          _buildMainCategory(
            title: 'Personal Details',
            icon: Icons.person,
            subItems: [
              _buildTextFormField(label: 'Name'),
              _buildTextFormField(label: 'Surname'),
              _buildTextFormField(label: 'Pronounce'),
              _buildTextFormField(label: 'Age'),
              _buildGenderFormField(),
              _buildTextFormField(label: 'Country'),
              _buildTextFormField(label: 'City'),
              _buildTextFormField(label: 'Phone'),
              _buildTextFormField(label: 'E-Mail'),
              _buildSafetyCheckbox(),
            ],
          ),
          _buildMainCategory(
            title: 'Subscriptions',
            icon: Icons.monetization_on,
            subItems: [
              _buildSubscriptionFormField(),
            ],
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

  Widget _buildMainCategory({
    required String title,
    required IconData icon,
    required List<Widget> subItems,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        ...subItems,
      ],
    );
  }

  Widget _buildTextFormField({required String label}) {
    TextInputType keyboardType = TextInputType.text;

    if (label == 'Phone') {
      keyboardType = TextInputType.phone;
    } else if (label == 'Age') {
      keyboardType = TextInputType.number;
    } else if (label == 'E-Mail') {
      keyboardType = TextInputType.emailAddress;
    } else if (label == 'Country' || label == 'City') {
      keyboardType = TextInputType.streetAddress;
    } else if (label == 'Name' || label == 'Surname') {
      keyboardType = TextInputType.name;
    } else {
      keyboardType = TextInputType.text;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        onChanged: (value) {
          setState(() {
            _hasChanges = true;
          });
        },
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildGenderFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<Gender>(
        decoration: const InputDecoration(
          labelText: 'Gender',
        ),
        value: selectedGender,
        onChanged: (value) {
          setState(() {
            selectedGender = value ?? Gender.other;
            _hasChanges = true;
          });
        },
        items: Gender.values.map<DropdownMenuItem<Gender>>((Gender value) {
          return DropdownMenuItem<Gender>(
            value: value,
            child: Text(value.displayName),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSafetyCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Checkbox(
            value: isSafe,
            onChanged: (value) {
              setState(() {
                isSafe = value ?? false;
                _hasChanges = true;
              });
            },
          ),
          const SizedBox(width: 8.0),
          const Flexible(
            child: Text(
              'Do you feel safe? Especially when you are alone or/and at night?',
              softWrap: true, // Added this line
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSubscriptionFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<SubscriptionType>(
        decoration: const InputDecoration(
          labelText: 'Subscription',
        ),
        value: selectedSubscription,
        onChanged: (value) {
          setState(() {
            selectedSubscription = value ?? SubscriptionType.basic;
            _hasChanges = true;
          });
        },
        items: SubscriptionType.values
            .map<DropdownMenuItem<SubscriptionType>>((SubscriptionType value) {
          return DropdownMenuItem<SubscriptionType>(
            value: value,
            child: Text(value.displayName),
          );
        }).toList(),
      ),
    );
  }
}

enum Gender {
  male,
  female,
  diverse,
  other;
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.diverse:
        return 'Diverse';
      case Gender.other:
        return 'Other';
    }
  }
}

enum SubscriptionType {
  basic,
  safe,
  family,
  travel;
}

extension SubscriptionTypeExtension on SubscriptionType {
  String get displayName {
    switch (this) {
      case SubscriptionType.basic:
        return 'Basic';
      case SubscriptionType.safe:
        return 'Safe Alone';
      case SubscriptionType.family:
        return 'Safe-Family';
      case SubscriptionType.travel:
        return 'Travel-Safe';
    }
  }
}
