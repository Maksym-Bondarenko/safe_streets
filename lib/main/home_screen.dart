import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:safe_streets/info_pages/edit_user_details_page.dart';
import 'package:safe_streets/main/filter_map.dart';
import 'package:safe_streets/info_pages/faq_page.dart';

import '../authentication/auth_gate.dart';
import '../info_pages/email_sender.dart';
import '../forum/forum_page.dart';
import '../info_pages/settings_page.dart';
import '../info_pages/support_page.dart';
import 'dds_map.dart';

/// Home-screen after authentication, containing dashboard with main information,
/// settings, and navigation to further pages
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO: modulise the content into different files
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthGate()));
                      })
                    ],
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.place, size: 48),
                                          SizedBox(height: 20),
                                          Text('10',
                                              style: TextStyle(fontSize: 18)),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('DangerPoints',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.place_outlined, size: 48),
                                          SizedBox(height: 20),
                                          Text('2',
                                              style: TextStyle(fontSize: 18)),
                                          Text('RecommendationPoints',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SettingsPage(
                                                  notificationsEnabled: true,
                                                  selectedThemeIndex: 0,
                                                  onToggleNotifications:
                                                      (bool) {
                                                    print(
                                                        "Notification are toggled on: $bool");
                                                  },
                                                  themeNames: const [
                                                    'Light',
                                                    'Dark',
                                                    'System'
                                                  ],
                                                  onChangeTheme: (int) {
                                                    print(
                                                        "Thema was changed to: $int");
                                                  },
                                                )));
                                  },
                                  child: const Text(
                                    "Settings",
                                    style: TextStyle(color: Colors.black),
                                  ),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditUserDetailsPage(
                                                    name: "Keira",
                                                    email:
                                                        "kiralovessmile@gmail.com",
                                                    phoneNumber:
                                                        "1234567890")));
                                  },
                                  child: const Text(
                                    "Change User Details",
                                    style: TextStyle(color: Colors.black),
                                  ),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EmailSender()));
                                  },
                                  child: const Text(
                                    "Contact Support",
                                    style: TextStyle(color: Colors.black),
                                  ),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const FaqPage()));
                                  },
                                  child: const Text(
                                    "FAQs",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          AspectRatio(
                            aspectRatio: 1,
                            child:
                                Image.asset('lib/assets/images/logo_big.png'),
                          ),
                        ]),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Card(
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ForumPage()))
                            },
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
                                    "Join area chats and discuss points, meet community mates and many more!"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Card(
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SupportPage()))
                            },
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
                                    "Search for official emergency contacts in your country."),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to FilterPoints-map
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FilterMap()));
                        },
                        child: const Text(
                          "Filter-based Map",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to DDS-map
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DDSMap()));
                        },
                        child: const Text(
                          "Rank-based Map",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
