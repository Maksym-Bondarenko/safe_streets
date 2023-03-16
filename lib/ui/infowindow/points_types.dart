import 'package:flutter/material.dart';

enum DangerPoints {
  lightPoint,
  cleanlinessPoint,
  peoplePoint,
  animalsPoint,
  roadPoint,
  childrenPoint,
  surroundingsPoint,
  otherPoint;
}

extension ParseToString on DangerPoints {

  // returns a name for the custom point of user
  String get name {
    switch (this) {
      case DangerPoints.lightPoint:
        return 'Dark Street';
      case DangerPoints.cleanlinessPoint:
        return 'Dirty Place';
      case DangerPoints.peoplePoint:
        return 'Dangerous People';
      case DangerPoints.animalsPoint:
        return 'Wild Animals';
      case DangerPoints.roadPoint:
        return 'Bad Road';
      case DangerPoints.childrenPoint:
        return 'Danger for Children';
      case DangerPoints.surroundingsPoint:
        return 'Uncomfortable Surroundings';
      case DangerPoints.otherPoint:
        return 'Other';
      default:
        return 'Other';
    }
  }

  // returns a corresponding icon to the custom user point (for info-window)
  Icon get icon {
    switch (this) {
      case DangerPoints.lightPoint:
        return const Icon(Icons.flashlight_off, size: 50.0);
      case DangerPoints.cleanlinessPoint:
        return const Icon(Icons.cleaning_services, size: 50.0);
      case DangerPoints.peoplePoint:
        return const Icon(Icons.person_search, size: 50.0);
      case DangerPoints.animalsPoint:
        return const Icon(Icons.pets, size: 50.0);
      case DangerPoints.roadPoint:
        return const Icon(Icons.remove_road, size: 50.0);
      case DangerPoints.childrenPoint:
        return const Icon(Icons.escalator_warning, size: 50.0);
      case DangerPoints.surroundingsPoint:
        return const Icon(Icons.foundation, size: 50.0);
      case DangerPoints.otherPoint:
        return const Icon(Icons.dangerous, size: 50.0);
      default:
        return const Icon(Icons.dangerous, size: 50.0);
    }
  }

  // returns a corresponding marker source-path to the custom user point (for the map-marker)
  String get markerSrc {
    switch (this) {
      case DangerPoints.lightPoint:
        return "lib/assets/marker/light_point_marker.png";
      case DangerPoints.cleanlinessPoint:
        return "lib/assets/marker/cleanliness_point_marker.png";
      case DangerPoints.peoplePoint:
        return "lib/assets/marker/people_point_marker.png";
      case DangerPoints.animalsPoint:
        return "lib/assets/marker/animals_point_marker.png";
      case DangerPoints.roadPoint:
        return "lib/assets/marker/road_point_marker.png";
      case DangerPoints.childrenPoint:
        return "lib/assets/marker/children_point_marker.png";
      case DangerPoints.surroundingsPoint:
        return "lib/assets/marker/surroundings_point_marker.png";
      case DangerPoints.otherPoint:
        return "lib/assets/marker/danger_point_marker.png";
      default:
        return "lib/assets/marker/danger_point_marker.png";
    }
  }

  // returns a corresponding color to the custom user point (for info-window)
  int get colorR {
    return 219;
  }
  int get colorG {
    return 68;
  }
  int get colorB {
    return 55;
  }
}

// TODO
enum SafePoints {
  restaurant,
  police,
  grocery;
}