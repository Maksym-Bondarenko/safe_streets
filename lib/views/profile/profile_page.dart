import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:safe_streets/router.dart';

// Profile settings page of the main tabs
class ProfilePage extends StatelessWidget implements PreferredSizeWidget {
  const ProfilePage({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      actions: [
        SignedOutAction((context) => AuthRoute().go(context)),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display danger points and recommendation points
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.place,
                                size: 48,
                              ),
                              SizedBox(height: 20),
                              Text(
                                '10',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'DangerPoints',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.place_outlined, size: 48),
                              SizedBox(height: 20),
                              Text(
                                '2',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'RecommendationPoints',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ElevatedButton(
                child: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => const SettingsRoute().push(context),
              ),
              ElevatedButton(
                child: const Text(
                  "Change User Details",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => const EditProfileRoute().push(context),
              ),
              ElevatedButton(
                child: const Text(
                  "Contact Support",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => const ContactSupportRoute().push(context),
              ),
              ElevatedButton(
                child: const Text(
                  "FAQs",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => const FAQRoute().push(context),
              ),
              const Divider(),
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset('assets/images/logo_big.png'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
