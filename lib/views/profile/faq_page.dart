import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // List of questions
  List<String> questions = [
    'How can the app help you feel safer?',
    'What is the difference between the two listed types of maps?',
    'What are three types of points about?',
  ];

  // Corresponding list of answers
  List<String> answers = [
    'Informative points and rank-based maps (currently are not integrated in our app, as it is under development for Flutter) provide you with information regarding potential danger that might occur while getting around the city on your own.',
    'Filter-based maps are providing 3 types of informative points, while rank-based maps are showing city areas, divided by different danger colours.',
    'Danger is a high recommendation to avoid the place. Recommendation is a medium recommendation to be careful. Safe is an open public place, which might be used as a shelter in case of emergency.',
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
                // Question title
                title: Text(
                  questions[index],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Expand/collapse callback
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _selectedIndex = expanded ? index : -1;
                  });
                },
                initiallyExpanded: _selectedIndex == index,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    // Answer text
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
