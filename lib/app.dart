import 'package:flutter/material.dart';

import 'authentication/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget represents the root of application
    return MaterialApp(
      // Define the theme for application
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColorDark: Colors.indigo,
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
      // Set AuthGate as the initial screen of application
      home: const AuthGate(),
      // Disable the debug mode banner
      debugShowCheckedModeBanner: false,
    );
  }
}
