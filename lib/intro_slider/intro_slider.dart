import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:safe_streets/home/home.dart';

class IntroSliderRules extends StatefulWidget {
  const IntroSliderRules({Key? key}) : super(key: key);

  @override
  _IntroSliderRulesState createState() => _IntroSliderRulesState();
}

class _IntroSliderRulesState extends State<IntroSliderRules> {
  List<Slide> slides = [];

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      colorActiveDot: Colors.white,
      onDonePress: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()))
      },
      onSkipPress: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()))
      },
      autoScroll: false,
    );
  }

  @override
  void initState() {
    super.initState();
    slides.add(
      Slide(
        title: "Safe Streets Maps: what is it?",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        maxLineTitle: 3,
        textOverFlowTitle: TextOverflow.ellipsis,
        description:
            'Safe Streets assists girls, children, seniors, and other groups that don’t feel safe while getting around the city on their own.\n\n'
            'We provide you with supportive information about specific area issues, suspicious people, dander zones, or on the contrary, safe places such as open cafes late at night.',
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        pathImage: "lib/assets/intro/page_1.png",
        heightImage: 250,
        foregroundImageFit: BoxFit.fitHeight,
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.white,
      ),
    );
    slides.add(
      Slide(
        title: "Filter-Based Map",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        maxLineTitle: 3,
        textOverFlowTitle: TextOverflow.ellipsis,
        description:
            'Simply open the filter-based map and apply what exactly you want to take into account: danger points, recommendations, or safe spaces.\n\n'
            'After that, you will be able to see users’ points on the map or create yours.',
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        pathImage: "lib/assets/intro/page_2.png",
        heightImage: 250,
        foregroundImageFit: BoxFit.fitHeight,
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.white,
      ),
    );
    slides.add(
      Slide(
        title: "Creating and checking points",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        maxLineTitle: 3,
        textOverFlowTitle: TextOverflow.ellipsis,
        description:
            'To create a point press long on a map and choose a relevant type of point, danger or recommendation, and a relevant type of issue from the list.\n\n'
            'To read others’ points click on the existing geo-point and read the information mentioned. Additionally, you can rely on the validity by seeing the number of “pluses” proven.',
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        pathImage: "lib/assets/intro/page_3.png",
        heightImage: 250,
        foregroundImageFit: BoxFit.fitHeight,
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.white,
      ),
    );
    slides.add(
      Slide(
        title: "Rank-based map",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        maxLineTitle: 3,
        textOverFlowTitle: TextOverflow.ellipsis,
        description:
            'Worried about whether the new city you are visiting is safe in general?\n\n'
            'Then, open the rank-based map and observe the colored visualisation of official crime statistics by each of the city areas.',
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        pathImage: "lib/assets/intro/page_4.png",
        heightImage: 250,
        foregroundImageFit: BoxFit.fitHeight,
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.white,
      ),
    );
    slides.add(
      Slide(
        title: "Community Forum & Support",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        maxLineTitle: 3,
        textOverFlowTitle: TextOverflow.ellipsis,
        description:
            'Feeling safe starts with area knowledge from reliable sources. Join necessary chats in the Forum and discuss suspicious points, news, events, and many more!\n\n'
            'Don’t forget to read and remember the main emergency numbers in our Support zone. However, we really hope you will never need to use them!',
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        pathImage: "lib/assets/intro/page_5.png",
        heightImage: 250,
        foregroundImageFit: BoxFit.fitHeight,
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.white,
      ),
    );
    slides.add(
      Slide(
        title: "User Profile",
        styleTitle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        maxLineTitle: 3,
        textOverFlowTitle: TextOverflow.ellipsis,
        description:
            'Finally, see how many points you have created on the user profile page. If needed, adjust settings for your account.\n\n'
            'Wishing you a safe journey, good luck!',
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        pathImage: "lib/assets/intro/page_6.png",
        heightImage: 250,
        foregroundImageFit: BoxFit.fitHeight,
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.white,
      ),
    );
  }
}
