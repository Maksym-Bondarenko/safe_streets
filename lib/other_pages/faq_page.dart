import 'dart:convert';

import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<FaqData> faqs = [];

  @override
  void initState() {
    super.initState();
    loadFaqData();
  }

  Future<void> loadFaqData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/faq_data.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    setState(() {
      faqs = jsonData.map((data) => FaqData.fromJson(data)).toList();
    });
  }

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
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2,
              child: ExpansionTile(
                // Question title
                title: Text(
                  faqs[index].question,
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
                      faqs[index].answer,
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

class FaqData {
  final String question;
  final String answer;

  FaqData({required this.question, required this.answer});

  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

