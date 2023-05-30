import 'package:flutter/material.dart';
import 'package:safe_streets/main/filter_map.dart';

import '../forum/forum_page.dart';
import '../info_pages/support_page.dart';
import 'dds_map.dart';
import 'main_settings.dart';

/// Home-screen after authentication, containing dashboard with main information,
/// settings, and navigation to further pages
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainSettings(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 80.0),
                child: Text(
                  "From\nSafe Streets\nto safe cities,\ncountries, and\nthe world!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Divider(),
              // Forum card
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ForumCard(
                        onTap: () {
                          // Navigate to the forum page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForumPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: SupportCard(
                        onTap: () {
                          // Navigate to the support page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SupportPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Filter-based Map button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the FilterPoints-map
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FilterMap(),
                    ),
                  );
                },
                child: const Text(
                  "Filter-based Map",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // Rank-based Map button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the DDS-map
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DDSMap(),
                    ),
                  );
                },
                child: const Text(
                  "Rank-based Map",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Forum card widget
class ForumCard extends StatelessWidget {
  final VoidCallback onTap;

  const ForumCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      color: Colors.white,
      borderOnForeground: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.blue,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTap,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                "Forum",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              "Join area chats and discuss points, meet community mates and many more!",
            ),
          ],
        ),
      ),
    );
  }
}

/// Support card widget
class SupportCard extends StatelessWidget {
  final VoidCallback onTap;

  const SupportCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      color: Colors.white,
      borderOnForeground: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.blue,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTap,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                "Support",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              "Search for official emergency contacts in your country.",
            ),
          ],
        ),
      ),
    );
  }
}
