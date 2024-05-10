import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import 'package:safe_streets/constants.dart';

class Slide extends ContentConfig {
  const Slide({
    super.title,
    super.description,
    required String imagePath,
  }) : super(
          pathImage: 'assets/intro/$imagePath',
          backgroundImageFit: BoxFit.fitHeight,
          backgroundColor: kWhite,
          maxLineTitle: 2,
          maxLineTextDescription: 5,
          styleTitle: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: kTextL,
          ),
          styleDescription: const TextStyle(
            color: kGrey,
            fontSize: kTextM,
          ),
          widthImage: 250,
          heightImage: 250,
        );
}
