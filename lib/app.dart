import 'package:flutter/material.dart';

import 'authentication/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColorDark: Colors.indigo,
        useMaterial3: false,
      ),
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
