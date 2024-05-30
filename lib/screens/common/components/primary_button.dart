import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class PrimaryButton extends ElevatedButton {
  PrimaryButton({
    super.key,
    required super.onPressed,
    required super.child,
    Color? color,
    Color? backgroundColor,
  }) : super(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? kGreen,
            foregroundColor: backgroundColor ?? kWhite,
            shape: const StadiumBorder(),
          ),
        );
}
