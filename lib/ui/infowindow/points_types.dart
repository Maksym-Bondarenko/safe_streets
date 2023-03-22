import 'package:flutter/material.dart';

// class for all possible points in the app: DangerPoint, SafePoint, RecommendationPoint
abstract class MapPoints {

  // custom point on the map can be either a 'DangerPoint', 'InformationPoint' or a 'SafePoint' (cannot be created manually)
  String get type;

  // each point has it corresponding color
  int get colorR => 0;
  int get colorG => 0;
  int get colorB => 0;

  // each point has its corresponding marker
  String get markerSrc => "lib/assets/marker/danger_point_marker.png";

}

enum DangerPoints implements MapPoints {
  lightPoint,
  cleanlinessPoint,
  peoplePoint,
  animalsPoint,
  roadPoint,
  childrenPoint,
  surroundingsPoint,
  otherPoint;

  @override
  String get type {
    return "DangerPoint";
  }

  // set custom color (red) for DangerPoints
  @override
  int get colorR {
    return 219;
  }
  @override
  int get colorG {
    return 68;
  }
  @override
  int get colorB {
    return 55;
  }

  // set custom markers for DangerPoints (differ from sub-type)
  @override
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
}

extension DangerPointsDetails on DangerPoints {

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
}

// TODO
enum RecommendationPoints implements MapPoints {
  cultural,
  traditional;

  @override
  String get type {
    return "RecommendationPoint";
  }

  @override
  int get colorR {
    return 66;
  }
  @override
  int get colorG {
    return 133;
  }
  @override
  int get colorB {
    return 244;
  }

  @override
  String get markerSrc => "lib/assets/marker/touristic_point_marker.png";
}

extension RecommendationPointsDetails on RecommendationPoints {

  // returns a name for the custom point of user
  String get name {
    switch (this) {
      case RecommendationPoints.cultural:
        return 'Cultural Differences';
      case RecommendationPoints.traditional:
        return 'Certain Traditions';
      default:
        return 'Other';
    }
  }

  Icon get icon {
    return const Icon(Icons.info, size: 50.0);
  }
}

// TODO
enum SafePoints implements MapPoints {
  restaurant,
  police,
  grocery;

  @override
  String get type {
    return "SafePoint";
  }

  @override
  int get colorR => 15;
  @override
  int get colorG => 157;
  @override
  int get colorB => 88;

  @override
  String get markerSrc => "lib/assets/marker/safe_point_marker.png";
}

extension SafePointsDetails on SafePoints {

  Icon get icon {
    return const Icon(Icons.health_and_safety, size: 50.0);
  }

}