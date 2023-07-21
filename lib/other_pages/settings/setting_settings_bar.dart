import 'package:flutter/material.dart';

class SettingsBottomBar extends StatelessWidget {
  final bool hasChanges;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const SettingsBottomBar({
    Key? key,
    required this.hasChanges,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: hasChanges ? onCancel : null,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  hasChanges ? Colors.red : Colors.grey,
                ),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: hasChanges ? onSave : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  hasChanges ? Colors.blue : Colors.grey,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
