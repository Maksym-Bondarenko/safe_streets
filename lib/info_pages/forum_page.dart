import 'package:flutter/material.dart';

import '../ui/custom_app_bar.dart';

class CardItem {
  final String title;
  final String subtitle;

  CardItem(this.title, this.subtitle);
}

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<CardItem> _cardItems = [
    CardItem('Garching', 'Munich'),
    CardItem('Schwabing', 'Munich'),
    CardItem('Munich', 'Germany'),
    CardItem('Berlin', 'Germany'),
    CardItem('Bavaria', 'Germany'),
    CardItem('Frankfurt', 'Germany'),
    CardItem('Germany', ''),
    CardItem('Bogenhausen', 'Munich'),
  ];

  List<CardItem> _filteredCardItems = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredCardItems = _cardItems;
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _filteredCardItems = _cardItems;
        });
      } else {
        List<CardItem> tempList = [];
        _cardItems.forEach((cardItem) {
          if (cardItem.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())) {
            tempList.add(cardItem);
          }
        });
        setState(() {
          _filteredCardItems = tempList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Forum')),
      appBar: const CustomAppBar(title: 'Forum'),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              controller: _searchController,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCardItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _filteredCardItems[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _filteredCardItems[index].subtitle,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat),
                  color: _selectedIndex == 0 ? Colors.black : Colors.white,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    // Navigate to 'Your Chats' page
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  color: _selectedIndex == 1 ? Colors.black : Colors.white,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    // Navigate to 'Filters' page
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  color: _selectedIndex == 2 ? Colors.black : Colors.white,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    // Navigate to 'Favorites' page
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
