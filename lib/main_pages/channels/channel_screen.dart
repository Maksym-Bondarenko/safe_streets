import 'package:flutter/material.dart';
import 'package:safe_streets/main_pages/channels/create_news_screen.dart';

import 'news_message.dart';

class ChannelScreen extends StatelessWidget {
  final Channel channel;

  const ChannelScreen({Key? key, required this.channel}) : super(key: key);

  void _navigateToCreateNewsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNewsScreen(channelTitle: channel.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch the user role (e.g., moderator) from Firebase authentication
    bool isModerator = true;

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
        floatingActionButton:
            _buildModeratorCreatePostButton(context, isModerator, channel));
  }

  Widget _buildModeratorCreatePostButton(
      BuildContext context, bool isModerator, Channel channel) {
    return Visibility(
      visible: isModerator,
      // Show the floating button only if the user is a moderator
      child: FloatingActionButton(
        onPressed: () => _navigateToCreateNewsScreen(context),
        child: const Icon(Icons.post_add),
      ),
    );
  }
}

class Channel {
  final String name;
  final List<NewsMessage> newsMessages;

  Channel(this.name, this.newsMessages);
}
