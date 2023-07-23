import 'package:flutter/material.dart';
import 'package:safe_streets/ui/bottom_menu/bottom_navigation_bar.dart';

import 'channel_screen.dart';
import 'news_message.dart';

class NewsChannelPage extends StatefulWidget {
  const NewsChannelPage({super.key});

  @override
  _NewsChannelPageState createState() => _NewsChannelPageState();
}

class _NewsChannelPageState extends State<NewsChannelPage> {
  final List<Channel> allChannels = [
    Channel(
      'Germany',
      [
        NewsMessage(
          title: 'Title 1',
          text: 'Text 1',
          source: 'Source 1',
          link: 'Link 1',
          date: DateTime.now(),
        ),
        NewsMessage(
          title: 'Title 2',
          text: 'Text 2',
          source: 'Source 2',
          link: 'Link 2',
          date: DateTime.now(),
        ),
        // Add more news messages here for Germany channel
      ],
    ),
    Channel(
      'Berlin',
      [
        NewsMessage(
          title: 'Title A',
          text: 'Text A',
          source: 'Source A',
          link: 'Link A',
          date: DateTime.now(),
        ),
        NewsMessage(
          title: 'Title B',
          text: 'Text B',
          source: 'Source B',
          link: 'Link B',
          date: DateTime.now(),
        ),
        // Add more news messages here for Berlin channel
      ],
    ),
    Channel(
      'Munich',
      [
        NewsMessage(
          title: 'Title X',
          text: 'Text X',
          source: 'Source X',
          link: 'Link X',
          date: DateTime.now(),
        ),
        NewsMessage(
          title: 'Title Y',
          text: 'Text Y',
          source: 'Source Y',
          link: 'Link Y',
          date: DateTime.now(),
        ),
        // Add more news messages here for Munich channel
      ],
    ),
    Channel(
      'Garching',
      [
        NewsMessage(
          title: 'Title P',
          text: 'Text P',
          source: 'Source P',
          link: 'Link P',
          date: DateTime.now(),
        ),
        NewsMessage(
          title: 'Title Q',
          text: 'Text Q',
          source: 'Source Q',
          link: 'Link Q',
          date: DateTime.now(),
        ),
        // Add more news messages here for Garching channel
      ],
    ),
    // Add more channels here
  ];
  List<Channel> filteredChannels = [];
  late List<bool> toggleSelection;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize toggle selection with true for all channels
    toggleSelection = List.generate(allChannels.length, (_) => true);
    // At the beginning, show all channels
    filteredChannels = List.from(allChannels);
  }

  void _filterChannels(String keyword) {
    setState(() {
      // Filter the channels based on the keyword and selected toggle buttons
      filteredChannels = allChannels
          .where((channel) =>
              channel.name.toLowerCase().contains(keyword.toLowerCase()) &&
              toggleSelection[allChannels.indexOf(channel)])
          .toList();
    });
  }

  void _toggleChannelSelection(int index) {
    setState(() {
      // Toggle the selection of the channel
      toggleSelection[index] = !toggleSelection[index];
      // Check if all other channels are selected or not
      bool allSelected =
          toggleSelection.sublist(1).every((isSelected) => isSelected);
      // Update the "All" button based on the selection of other channels
      toggleSelection[0] = allSelected;
      // Filter the channels again based on the updated toggle selection
      _filterChannels(searchController.text);
    });
  }

  void _toggleAllSelection() {
    setState(() {
      // Toggle the selection of the "All" button
      toggleSelection[0] = !toggleSelection[0];
      // Check if any of the other toggle buttons are not selected
      bool anyOtherNotSelected =
          toggleSelection.sublist(1).any((isSelected) => !isSelected);
      // If any other toggle button is not selected, update the "All" button accordingly
      if (anyOtherNotSelected) {
        toggleSelection[0] = false;
      }
      // Filter the channels again based on the updated toggle selection
      _filterChannels(searchController.text);
    });
  }

  void _clearSearch() {
    setState(() {
      // Clear the search bar text and filter the channels
      searchController.clear();
      _filterChannels('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Channels'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildToggleFilters(),
          const Divider(),
          _buildListOfChannels(),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        onChanged: _filterChannels,
        decoration: InputDecoration(
          hintText: 'Search channels...',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            RoundedToggleButton(
              text: 'All',
              isSelected: toggleSelection[0],
              onPressed: _toggleAllSelection,
            ),
            const VerticalDivider(thickness: 2.0),
            const SizedBox(width: 8.0),
            ...allChannels.map(
              (channel) => RoundedToggleButton(
                text: channel.name,
                isSelected: toggleSelection[allChannels.indexOf(channel)],
                onPressed: () =>
                    _toggleChannelSelection(allChannels.indexOf(channel)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListOfChannels() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredChannels.length,
        itemBuilder: (context, index) {
          final channel = filteredChannels[index];
          return ListTile(
            title: Text(channel.name),
            subtitle: Text('${channel.newsMessages.length} articles'),
            onTap: () {
              // Navigate to the respective channel screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChannelScreen(channel: channel),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RoundedToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const RoundedToggleButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isAllButton = text == 'All';

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAllButton
              ? (isSelected ? Colors.blue : Colors.grey)
              : (isSelected ? Colors.blue : Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
