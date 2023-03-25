import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:safe_streets/home/start_page.dart';

import '../info_pages/forum_page.dart';
import '../info_pages/support_page.dart';
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.place, size: 48),
                                  SizedBox(height: 20),
                                  Text('10', style: TextStyle(fontSize: 18)),
                                  Text('DangerPoints',
                                      style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.place_outlined, size: 48),
                                  SizedBox(height: 20),
                                  Text('2', style: TextStyle(fontSize: 18)),
                                  Text('RecommendationPoints',
                                      style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Settings"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Change User Details"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Contact Support"),
                              ),
                            ),
                          ],
                        ),
                      ),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 5,
                    borderOnForeground: true,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForumPage()))
                      },
                      child: Column(
                        children: const [
                          Text(
                            "Forum",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                              "Join area chats and discuss points, meet community mates and many more!"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 5,
                    borderOnForeground: true,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SupportPage()))
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Support",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                              "Search for official emergency contacts in your country."),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Data Drive Styling map
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DDSMap()));
                    },
                    child: const Text("Filter-based Map"),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to main ranking map
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StartPage()));
                    },
                    child: const Text("Rank-based Map"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
