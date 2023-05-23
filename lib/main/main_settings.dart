import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../authentication/auth_gate.dart';
import '../info_pages/edit_user_details_page.dart';
import '../info_pages/email_sender.dart';
import '../info_pages/faq_page.dart';
import '../info_pages/settings_page.dart';

/// Main Settings by clicking on the Profile-icon on the home-screen
class MainSettings extends StatelessWidget {
  const MainSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

}