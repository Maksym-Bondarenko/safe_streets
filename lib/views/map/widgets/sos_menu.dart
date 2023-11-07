import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/router.dart';

class SOSMenu extends StatelessWidget {
  const SOSMenu({super.key});

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
        SpeedDialChild(
          child: const Icon(Icons.call, color: Colors.white),
          labelWidget: const _Label('Fake-Call'),
          backgroundColor: kBlack,
          onTap: () => CallRoute().push(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.sos, color: Colors.white),
          labelWidget: const _Label('SOS'),
          backgroundColor: kBlack,
          onTap: _sosPressed,
        ),
        SpeedDialChild(
          child: const Icon(Icons.share_location, color: Colors.white),
          labelWidget: const _Label('Share Location'),
          backgroundColor: kBlack,
          onTap: _shareLocation,
        ),
      ],
    );
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

class _Label extends StatelessWidget {
  final String _text;

  const _Label(
    String label, {
    super.key,
  }) : _text = label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kSpacingSM),
      child: Text(
        _text,
        style: const TextStyle(
          fontSize: kTextS,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
