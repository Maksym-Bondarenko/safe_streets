import 'package:flutter/material.dart';

class NewsMessageCard extends StatelessWidget {
  final NewsMessage newsMessage;

  const NewsMessageCard({Key? key, required this.newsMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    newsMessage.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatDate(newsMessage.date),
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      newsMessage.source,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              newsMessage.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                // Implement logic to open the link
              },
              child: const Text('Read More'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format date as yyyy-mm-dd, hh:mm
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}, ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}";
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

class NewsMessage {
  final String title;
  final String text;
  final String source;
  final String link;
  final DateTime date;

  NewsMessage({
    required this.title,
    required this.text,
    required this.source,
    required this.link,
    required this.date,
  });
}
