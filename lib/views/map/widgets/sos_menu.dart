import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/router.dart';

class SOSMenu extends StatelessWidget {
  const SOSMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.sos,
      backgroundColor: kRed,
      spacing: kSpacingS,
      spaceBetweenChildren: kSpacingS,
      buttonSize: const Size(kLargeButton, kLargeButton),
      childrenButtonSize: const Size(kButton, kButton),
      childPadding: EdgeInsets.zero,
      visible: true,
      direction: SpeedDialDirection.up,
      curve: Curves.fastOutSlowIn,
      switchLabelPosition: true,
      children: [
        // Fake-Call Button
        SpeedDialChild(
            child: const Icon(Icons.call, color: Colors.white),
            backgroundColor: Colors.blue,
            onTap: _fakeCallPressed,
            label: 'Fake-Call',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black),
        // SOS Button
        SpeedDialChild(
          child: const Icon(Icons.sos, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: _sosPressed,
          label: 'SOS',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),

        // Share Location Button
        SpeedDialChild(
          child: const Icon(Icons.share_location, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: _shareLocation,
          label: 'Share Location',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }

  void _fakeCallPressed() {
    AppRouter.router.pushNamed(AppRoutes.incomingCall);
  }

// TODO: implement SOS-functionality
  void _sosPressed() {
    print('Pressed SOS');
  }

// TODO: implement share location functionality
  void _shareLocation() {
    print('Pressed Share Location');
  }
}
