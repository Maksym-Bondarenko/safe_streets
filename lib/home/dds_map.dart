import 'package:flutter/material.dart';

import '../ui/custom_app_bar.dart';

class DDSMap extends StatelessWidget {
  const DDSMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DDS-Map'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(children: [
          Column(
            children: [
              const Text(
                  "Currently DDS (Data-Driven-Styling) of Google Maps in Flutter is under development and expected to be released soon.\n"),
              const Text(
                  "As soon as DDS will be available in Flutter, we plan to add it to the map in our application.\n"),
              const Text(
                  "Below you can see the screenshots of implemented by us DDS in JS to have an understanding how might it look\n"),
              const Text(
                  "All the data is taken from the official Police-Statements of cities of Germany (Munich, Frankfurt and Berlin). Colors are based on percentage of crimes to amount of citized in each postal code area. With this information users can gain an understanding of 'safety' of each area, based on official police reports."),
              Image.asset(
                'lib/assets/dds/map_munich.png',
              ),
              const Text(
                "Munich, Germany",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              Image.asset(
                'lib/assets/dds/map_hamburg.png',
              ),
              const Text(
                "Hamburg, Germany",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
