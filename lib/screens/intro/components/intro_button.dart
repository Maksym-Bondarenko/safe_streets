import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class IntroButton extends Text {
  const IntroButton({
    super.key,
    required String text,
  }) : super(
          text,
          style: const TextStyle(
            color: kBlack,
            fontSize: kTextM,
            fontWeight: FontWeight.bold,
          ),
        );
}
