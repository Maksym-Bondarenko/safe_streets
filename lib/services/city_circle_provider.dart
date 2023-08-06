import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityCirclesProvider {
  static Future<Set<Circle>> getCirclesFromJson(BuildContext context) async {
    String json = await rootBundle.loadString('lib/assets/data/circle_area_info.json');
    List<dynamic> jsonData = jsonDecode(json);
    Set<Circle> circles = {};

    for (var cityData in jsonData) {
      double safetyIndex = cityData['safetyIndex'];

      Color fillColor = Colors.greenAccent;
      Color strokeColor = Colors.green;

      if (safetyIndex < 5) {
        fillColor = Colors.redAccent;
        strokeColor = Colors.red;
      } else if (safetyIndex < 7) {
        fillColor = Colors.orangeAccent;
        strokeColor = Colors.orange;
      } else if (safetyIndex < 8) {
        fillColor = Colors.yellowAccent;
        strokeColor = Colors.yellow;
      }

      circles.add(
        Circle(
          circleId: CircleId(cityData['id']),
          center: LatLng(cityData['latitude'], cityData['longitude']),
          radius: cityData['radius'].toDouble(),
          fillColor: fillColor.withOpacity(0.3),
          strokeColor: strokeColor,
          strokeWidth: 2,
          zIndex: 0,
          // show summarized information about the city by clicking
          onTap: () {
            print("pressed");

            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${cityData['country']}, ${cityData['city']}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Year: ${cityData['year']}, Safety Index: ${cityData['safetyIndex']}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cityData['info'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      // Add more information here
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    }

    return circles;
  }
}