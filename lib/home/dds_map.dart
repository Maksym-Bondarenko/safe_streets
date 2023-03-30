import 'package:flutter/material.dart';

class DDSMap extends StatelessWidget {
  const DDSMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DDS-Map')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(children: [
          Column(
            children: [
              const Text(
                  "Rank-based aims to introduce integrated crime-rate-based maps for major German cities. Police data is collected from the official crime reports for each administrative area.\n\n"),
              const Text(
                  "You’re welcome to scroll down and check Munich and Hamburg maps generated. New cities are coming soon!"),
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
