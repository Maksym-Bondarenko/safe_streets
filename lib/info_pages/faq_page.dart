import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<String> questions = [
    'What is Flutter?',
    'What are the benefits of using Flutter?',
    'What programming languages does Flutter use?',
    'What are Flutter widgets?',
    'What are Flutter plugins?'
  ];

  List<String> answers = [
    'Flutter is a mobile app development framework created by Google that allows developers to build high-performance, cross-platform apps for iOS and Android using a single codebase.',
    'Flutter offers several benefits to developers, including faster development times, hot reload functionality, a wide range of pre-built widgets, and excellent performance on both iOS and Android.',
    'Flutter uses the Dart programming language, which is also developed by Google. Dart is a modern, object-oriented programming language that is easy to learn and use.',
    'Flutter widgets are the building blocks of Flutter apps. They are reusable, customizable UI elements that allow developers to create beautiful and responsive user interfaces quickly and easily.',
    'Flutter plugins are packages of code that provide access to native device features, such as camera or Bluetooth functionality, from within a Flutter app.'
  ];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2,
              child: ExpansionTile(
                title: Text(
                  questions[index],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _selectedIndex = expanded ? index : -1;
                  });
                },
                initiallyExpanded: _selectedIndex == index,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      answers[index],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
