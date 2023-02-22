import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  int _test = 42;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Placeholder(color: Colors.orangeAccent),
      ),
    );
  }
  
}