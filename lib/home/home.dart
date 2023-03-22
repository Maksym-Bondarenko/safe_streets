import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:safe_streets/home/start_page.dart';

import '../terms_and_conditions/terms_and_conditions.dart';
import 'dds_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Image.asset('lib/assets/images/logo_small.png'),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset('lib/assets/images/logo_big.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('lib/assets/images/logo_big.png'),
            Text(
              'Welcome to SafeStreets!',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Data Drive Styling map
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DDSMap()));
              },
              child: const Text("Map Filters"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to main ranking map
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const StartPage()));
              },
              child: const Text("Map Rankings"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to terms and conditions
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsAndConditions()));
              },
              child: const Text("Terms & Conditions"),
            ),
          ],
        ),
      ),
    );
  }
}
