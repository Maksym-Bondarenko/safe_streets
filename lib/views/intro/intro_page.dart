import 'package:flutter/material.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:safe_streets/router.dart';

/// Intro-Slider, giving overview of the app
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Slide> slides = [];

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      colorActiveDot: Colors.white,
      autoScroll: false,
      renderNextBtn: _customRenderNextBtn(),
      renderDoneBtn: _customRenderDoneBtn(),
      renderSkipBtn: _customRenderSkipBtn(),
      onDonePress: () => _navigateToHome(context),
      onSkipPress: () => _navigateToHome(context),
    );
  }

  void _navigateToHome(BuildContext context) {
    const InfoRoute().go(context);
  }

  @override
  void initState() {
    super.initState();
    slides = SlideData.slides;
  }
}

Widget _customRenderSkipBtn() {
  return const Text(
    "Skip",
    style: IntroStyling.buttonsStyle,
  );
}

Widget _customRenderNextBtn() {
  return const Text(
    "Next",
    style: IntroStyling.buttonsStyle,
  );
}

Widget _customRenderDoneBtn() {
  return const Text(
    "Done",
    style: IntroStyling.buttonsStyle,
  );
}

// content of the slides (title, description, image)
class SlideData {
  static List<Slide> slides = [
    SlideTemplate(
      title: "Safe Streets Maps: what is it?",
      description:
          'Safe Streets assists girls, children, seniors, and other groups that don’t feel safe while getting around the city on their own.\n\n'
          'We provide you with supportive information about specific area issues, suspicious people, dander zones, or on the contrary, safe places such as open cafes late at night.',
      image: AppImages.intro1,
    ),
    SlideTemplate(
      title: "Filter-Based Map",
      description:
          'Simply open the filter-based map and apply what exactly you want to take into account: danger points, recommendations, or safe spaces.\n\n'
          'After that, you will be able to see users’ points on the map or create yours.',
      image: AppImages.intro2,
    ),
    SlideTemplate(
      title: "Creating and checking points",
      description:
          'To create a point press long on a map and choose a relevant type of point, danger or recommendation, and a relevant type of issue from the list.\n\n'
          'To read others’ points click on the existing geo-point and read the information mentioned. Additionally, you can rely on the validity by seeing the number of “pluses” proven.',
      image: AppImages.intro3,
    ),
    SlideTemplate(
      title: "Rank-based map",
      description:
          'Worried about whether the new city you are visiting is safe in general?\n\n'
          'Then, open the rank-based map and observe the colored visualisation of official crime statistics by each of the city areas.',
      image: AppImages.intro4,
    ),
    SlideTemplate(
      title: "Community Forum & Support",
      description:
          'Feeling safe starts with area knowledge from reliable sources. Join necessary chats in the Forum and discuss suspicious points, news, events, and many more!\n\n'
          'Don’t forget to read and remember the main emergency numbers in our Support zone. However, we really hope you will never need to use them!',
      image: AppImages.intro5,
    ),
    SlideTemplate(
      title: "User Profile",
      description:
          'Finally, see how many points you have created on the user profile page. If needed, adjust settings for your account.\n\n'
          'Wishing you a safe journey, good luck!',
      image: AppImages.intro6,
    ),
  ];
}

// common template for all slides
class SlideTemplate extends Slide {
  SlideTemplate({
    required String title,
    required String description,
    required String image,
  }) : super(
          title: title,
          description: description,
          pathImage: image,
          backgroundImageFit: BoxFit.fitHeight,
          backgroundColor: Colors.blueAccent,
          colorBegin: Colors.blueAccent,
          colorEnd: Colors.white,
          maxLineTextDescription: 3,
          styleTitle: IntroStyling.titleStyle,
          styleDescription: IntroStyling.descriptionStyle,
          widthImage: 250,
          heightImage: 250,
        );
}

// separating text-styling
class IntroStyling {
  static const titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static const descriptionStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  static const buttonsStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

// separating image-data
class AppImages {
  static const intro1 = "assets/intro/page_1.png";
  static const intro2 = "assets/intro/page_2.png";
  static const intro3 = "assets/intro/page_3.png";
  static const intro4 = "assets/intro/page_4.png";
  static const intro5 = "assets/intro/page_5.png";
  static const intro6 = "assets/intro/page_6.png";
}
