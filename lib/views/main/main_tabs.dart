import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safe_streets/constants.dart';

class MainTabs extends StatelessWidget {
  final StatefulNavigationShell _navigationShell;

  const MainTabs({
    super.key,
    required StatefulNavigationShell navigationShell,
  }) : _navigationShell = navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            label: 'Map',
            icon: Icon(Icons.map_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Info',
            icon: Icon(Icons.info_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person_outline),
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
