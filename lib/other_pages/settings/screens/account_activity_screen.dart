import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountActivityScreen extends StatefulWidget {
  const AccountActivityScreen({Key? key}) : super(key: key);

  @override
  _AccountActivityScreenState createState() => _AccountActivityScreenState();
}

class _AccountActivityScreenState extends State<AccountActivityScreen> {
  List<AccountActivity> activities = [
    AccountActivity(
      activity: 'Logged in',
      date: DateTime(2022, 10, 1, 14, 30),
    ),
    AccountActivity(
      activity: 'Added a comment',
      date: DateTime(2022, 9, 28, 9, 45),
    ),
    AccountActivity(
      activity: 'Built a safe path on map',
      date: DateTime(2022, 9, 26, 11, 15),
    ),
    AccountActivity(
      activity: 'Created a Danger Point',
      date: DateTime(2022, 9, 25, 16, 0),
    ),
    AccountActivity(
      activity: 'Created a Recommendation Point',
      date: DateTime(2022, 9, 23, 10, 30),
    ),
    AccountActivity(
      activity: 'Voted +1 on a point',
      date: DateTime(2022, 9, 20, 15, 20),
    ),
    AccountActivity(
      activity: 'Voted -1 on a point',
      date: DateTime(2022, 9, 18, 9, 0),
    ),
  ];

  List<AccountActivity> filteredActivities = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredActivities = activities;
  }

  void _filterActivities(String searchText) {
    setState(() {
      filteredActivities = activities
          .where((activity) =>
          activity.activity.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Activity'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterActivities,
              decoration: const InputDecoration(
                hintText: 'Search activities...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredActivities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredActivities[index].activity),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy, HH:mm').format(filteredActivities[index].date),
                  ),
                  trailing: _getActivityIcon(filteredActivities[index].activity),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Icon _getActivityIcon(String activity) {
    if (activity.contains('login')) {
      return const Icon(Icons.login);
    } else if (activity.contains('comment')) {
      return const Icon(Icons.comment);
    } else if (activity.contains('map')) {
      return const Icon(Icons.map);
    } else if (activity.contains('Danger Point')) {
      return const Icon(Icons.warning);
    } else if (activity.contains('Recommendation Point')) {
      return const Icon(Icons.thumb_up);
    } else if (activity.contains('Voted +1')) {
      return const Icon(Icons.thumb_up_alt);
    } else if (activity.contains('Voted -1')) {
      return const Icon(Icons.thumb_down_alt);
    } else {
      return const Icon(Icons.info);
    }
  }
}

class AccountActivity {
  final String activity;
  final DateTime date;

  AccountActivity({required this.activity, required this.date});
}
