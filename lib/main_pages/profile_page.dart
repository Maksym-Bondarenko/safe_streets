import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:share_plus/share_plus.dart';

import '../authentication/auth_gate.dart';
import '../other_pages/edit_user_details_page.dart';
import '../other_pages/settings_page.dart';
import '../shared/points_types.dart';
import '../ui/bottom_menu/bottom_navigation_bar.dart';
import '../ui/contributions/contribution.dart';
import '../ui/filters/toggle_buttons.dart';

/// Profile-page with user's contributions, settings, points, etc.
class ProfilePage extends StatefulWidget implements PreferredSizeWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfilePageState extends State<ProfilePage> {
  int totalContributions = 6;
  List<FilterType> selectedFilters = [FilterType.dangerPoints];
  List<Contribution> contributions = [
    Contribution(
        title: "title",
        description: "description",
        place: "Place",
        likes: 5,
        comments: 2,
        pointType: MainType.dangerPoint),
    Contribution(
        title: "title",
        description: "description",
        place: "Place",
        likes: 5,
        comments: 2,
        pointType: MainType.recommendationPoint),
    Contribution(
        title: "title",
        description: "description",
        place: "Place",
        likes: 5,
        comments: 2,
        pointType: MainType.safePoint),
    Contribution(
        title: "title",
        description: "description",
        place: "Place",
        likes: 5,
        comments: 2,
        pointType: MainType.safePoint),
    Contribution(
        title: "title",
        description: "description",
        place: "Place",
        likes: 5,
        comments: 2,
        pointType: MainType.dangerPoint),
    Contribution(
        title: "ACHTUNG!",
        description:
            "Something bad happaned on the street XX, when I went there. It was a YY and then happened ZZ!",
        place: "Munich",
        likes: 46,
        comments: 30,
        pointType: MainType.recommendationPoint)
  ];

  // sharing profile via build-in function
  void _shareProfile() {
    const String text = 'Check out my SafeStreets profile!';
    const String subject = 'My SafeStreets Profile';

    Share.share(text, subject: subject);
  }

  // Get the filtered contributions based on selected filters
  List<Contribution> _getFilteredContributions() {
    if (selectedFilters.contains(FilterType.all)) {
      return contributions;
    } else {
      return contributions.where((contribution) {
        return selectedFilters.contains(_getFilterType(contribution.pointType));
      }).toList();
    }
  }

  // Get the corresponding FilterType based on the pointType
  FilterType _getFilterType(MainType pointType) {
    switch (pointType) {
      case MainType.dangerPoint:
        return FilterType.dangerPoints;
      case MainType.recommendationPoint:
        return FilterType.recommendationPoints;
      case MainType.safePoint:
        return FilterType.safePoints;
    }
  }

  @override
  Widget build(BuildContext context) {
    var filteredContributions = _getFilteredContributions();

    return Scaffold(
      body: ProfileScreen(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        actions: [
          SignedOutAction((context) {
            // Navigate to the authentication gate
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthGate(),
              ),
            );
          }),
        ],
        avatarPlaceholderColor: Colors.lightBlue,
        children: <Widget> [
          const Divider(),
          _buildButtonsRow(context),
          const Divider(),
          const SizedBox(height: 10),
          _buildContributionSection(context, filteredContributions),
          const Divider(),
          // Display app logo
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset('lib/assets/images/logo_big.png'),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  // row of 4 rounded buttons: edit-profile, share, profile-settings and sign-out
  Widget _buildButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit_user');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12.0),
              ),
              child: const Icon(
                Icons.edit,
                size: 32.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _shareProfile();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12.0),
              ),
              child: const Icon(
                Icons.share,
                size: 32.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Share',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12.0),
              ),
              child: const Icon(
                Icons.settings,
                size: 32.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Profile Settings',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // navigate to the page with AI-camera to get street's elements
                Navigator.pushNamed(context, '/ai_camera');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12.0),
              ),
              child: const Icon(
                Icons.emergency_recording,
                size: 32.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Record Street',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // section with user's contributions: created/commented points, forum, etc.
  Widget _buildContributionSection(
      BuildContext context, List<Contribution> filteredContributions) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        Text(
          'My Contributions (${filteredContributions.length} / $totalContributions)',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ToggleButtonBar(
          selectedFilters: selectedFilters,
          onFilterChanged: (filters) {
            setState(() {
              selectedFilters = filters;
              filteredContributions = _getFilteredContributions();
            });
          },
          contributions: filteredContributions,
        ),
        const SizedBox(height: 20),
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: filteredContributions.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                child: ContributionCard(
                  contribution: filteredContributions[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

enum FilterType { all, dangerPoints, recommendationPoints, safePoints }
