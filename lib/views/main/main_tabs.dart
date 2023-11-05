import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safe_streets/constants.dart';

class MainTabs extends StatelessWidget {
  final StatefulNavigationShell _navigationShell;

  const MainTabs({
    super.key,
    required navigationShell,
  }) : _navigationShell = navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _navigationShell,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kLightGrey,
        selectedItemColor: kBlack,
        unselectedItemColor: kGrey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: kIcon,
        currentIndex: _navigationShell.currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outlined),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          _navigationShell.goBranch(
            index,
            initialLocation: index == _navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
