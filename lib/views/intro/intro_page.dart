import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/router.dart';

/// Intro-Slider, giving overview of the app
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: _slides,
      colorActiveDot: kBlack,
      autoScroll: false,
      renderNextBtn: const _IntroBtnText(text: 'Next'),
      renderDoneBtn: const _IntroBtnText(text: 'Done'),
      renderSkipBtn: const _IntroBtnText(text: 'Skip'),
      onSkipPress: () => const InfoRoute().go(context),
      onDonePress: () => const InfoRoute().go(context),
    );
  }
}

// common template for all slides
class _SlideTemplate extends Slide {
  _SlideTemplate({
    required String title,
    required String description,
    required String imagePath,
  }) : super(
          title: title,
          description: description,
          pathImage: 'assets/intro/$imagePath',
          backgroundImageFit: BoxFit.fitHeight,
          backgroundColor: kWhite,
          maxLineTextDescription: 3,
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

class _IntroBtnText extends Text {
  const _IntroBtnText({
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

// content of the slides (title, description, image)
final List<_SlideTemplate> _slides = [
  _SlideTemplate(
    title: "Safe Streets Maps: what is it?",
    description:
        'Safe Streets assists girls, children, seniors, and other groups that don’t feel safe while getting around the city on their own.\n\n'
        'We provide you with supportive information about specific area issues, suspicious people, dander zones, or on the contrary, safe places such as open cafes late at night.',
    imagePath: 'page_1.png',
  ),
  _SlideTemplate(
    title: "Filter-Based Map",
    description:
        'Simply open the filter-based map and apply what exactly you want to take into account: danger points, recommendations, or safe spaces.\n\n'
        'After that, you will be able to see users’ points on the map or create yours.',
    imagePath: 'page_2.png',
  ),
  _SlideTemplate(
    title: "Creating and checking points",
    description:
        'To create a point press long on a map and choose a relevant type of point, danger or recommendation, and a relevant type of issue from the list.\n\n'
        'To read others’ points click on the existing geo-point and read the information mentioned. Additionally, you can rely on the validity by seeing the number of “pluses” proven.',
    imagePath: 'page_3.png',
  ),
  _SlideTemplate(
    title: "Rank-based map",
    description:
        'Worried about whether the new city you are visiting is safe in general?\n\n'
        'Then, open the rank-based map and observe the colored visualisation of official crime statistics by each of the city areas.',
    imagePath: 'page_4.png',
  ),
  _SlideTemplate(
    title: "Community Forum & Support",
    description:
        'Feeling safe starts with area knowledge from reliable sources. Join necessary chats in the Forum and discuss suspicious points, news, events, and many more!\n\n'
        'Don’t forget to read and remember the main emergency numbers in our Support zone. However, we really hope you will never need to use them!',
    imagePath: 'page_5.png',
  ),
  _SlideTemplate(
    title: "User Profile",
    description:
        'Finally, see how many points you have created on the user profile page. If needed, adjust settings for your account.\n\n'
        'Wishing you a safe journey, good luck!',
    imagePath: 'page_6.png',
  ),
];
