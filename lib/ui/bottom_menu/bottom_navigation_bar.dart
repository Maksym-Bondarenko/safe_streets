import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/app_state.dart';

/// Navigation-bar on the bottom of each page to enable navigation between them in one click
class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentIndex = appState.currentIndex;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        appState.setIndex(index);

        // Navigation logic
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/support');
            break;
          case 2:
            Navigator.pushNamed(context, '/forum');
            break;
          case 3:
            Navigator.pushNamed(context, '/filterMap');
            break;
          case 4:
            Navigator.pushNamed(context, '/profile');
            break;
          // case 5:
          //   Navigator.pushNamed(context, '/settings');
          //   break;
        }
      },
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      elevation: 2.0,
      showSelectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support),
          label: 'Support',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: 'Forum',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
