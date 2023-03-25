import 'package:flutter/material.dart';

class DDSMap extends StatefulWidget {
  const DDSMap({Key? key}) : super(key: key);

  @override
  _DDSMapState createState() => _DDSMapState();
}

class _DDSMapState extends State<DDSMap> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text("Currently DDS (Data-Driven-Styling) of Google Maps in Flutter is under development and expected to be released soon."),
            const Text("As soon as DDS will be available in Flutter, we plan to add it to the map in our application."),
            const Text("Below you can see the screenshots of implemented by us DDS in JS to have an understanding how might it look"),
            const Text("All the data is taken from the official Police-Statements of cities of Germany (Munich, Frankfurt and Berlin). Colors are based on percentage of crimes to amount of citized in each postal code area. With this information users can gain an understanding of 'safety' of each area, based on official police reports."),
            Image.asset('lib/assets/dds/map_munich.png'),
          ],
        ),
      ),
    );
  }

}