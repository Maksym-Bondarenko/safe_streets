import 'package:flutter/material.dart';

import 'news_message.dart';

class ChannelScreen extends StatelessWidget {
  final Channel channel;

  const ChannelScreen({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort the newsMessages by date in descending order
    channel.newsMessages.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text("${channel.name} Channel"),
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: channel.newsMessages.length,
            itemBuilder: (context, index) {
              final newsMessage = channel.newsMessages[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: NewsMessageCard(newsMessage: newsMessage),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Channel {
  final String name;
  final List<NewsMessage> newsMessages;

  Channel(this.name, this.newsMessages);
}