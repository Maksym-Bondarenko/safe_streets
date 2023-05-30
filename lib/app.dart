import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:safe_streets/forum/forum_page.dart';
import 'package:safe_streets/main/dds_map.dart';
import 'package:safe_streets/main/filter_map.dart';

import 'authentication/auth_gate.dart';
import 'main/home_screen.dart';

/// Here the app is built and navigated to the @{AuthGate}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget represents the root of application
    return MaterialApp(
      title: "SafeStreets",
      // Define the theme for application
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColorDark: Colors.indigo,
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthGate(),
        '/intro': (context) => const IntroSlider(),
        '/ddsMap': (context) => const DDSMap(),
        '/filterMap': (context) => const FilterMap(),
        '/forum': (context) => const ForumPage(),
      },
      // Set AuthGate as the initial screen of application
      home: const AuthGate(),
      // Disable the debug mode banner
      debugShowCheckedModeBanner: false,
    );
  }
}
