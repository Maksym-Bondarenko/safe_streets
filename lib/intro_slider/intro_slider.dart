import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../home/start_page.dart';

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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const StartPage()))
      },
    );
  }

  @override
  void initState() {
    super.initState();
    slides.add(
      Slide(
        title: "Management",
        description:
            'Management is the administration of an organization, whether it is a business,'
            ' a non-profit organization, or a government body. ',
        pathImage: "lib/assets/images/dash.png",
        heightImage: 370,
        widthImage: 400,
        backgroundColor: const Color(0xff4266AC),
      ),
    );
    slides.add(
      Slide(
        title: "Chat",
        description:
            "Chat refers to the process of communicating, interacting and/or exchanging messages over the Internet. "
            "It involves two or more individuals that communicate through a chat-enabled service or software. ",
        pathImage: "lib/assets/images/flutterfire_300x.png",
        heightImage: 370,
        widthImage: 400,
        backgroundColor: const Color(0xff3852B2),
      ),
    );
    slides.add(
      Slide(
        title: "Leadership",
        description:
            "Leadership is the ability of an individual or a group of individuals to influence and guide followers or other members of an organization.  ",
        pathImage: "lib/assets/images/location_marker.png",
        heightImage: 370,
        widthImage: 400,
        backgroundColor: const Color(0xff2A78E6),
      ),
    );
  }
}
