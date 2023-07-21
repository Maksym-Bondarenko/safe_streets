import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('FAQ'),
            onTap: () {
              Navigator.pushNamed(context, '/faq');
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pushNamed(context, '/email');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('User Guide'),
            onTap: () {
              Navigator.pushNamed(context, '/intro');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report a Problem'),
            onTap: () {
              Navigator.pushNamed(context, '/email');
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pushNamed(context, '/email');
            },
          ),
          ListTile(
            leading: const Icon(Icons.system_update),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            onTap: () {
              // Handle App Version tap
            },
          ),
        ],
      ),
    );
  }
}
