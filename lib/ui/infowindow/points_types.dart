import 'package:flutter/material.dart';

// enum of 3 main Point types
enum MainType {
  dangerPoint,
  recommendationPoint,
  safePoint;
}

extension MainTypeDetails on MainType {
  String get name {
    switch (this) {
      case MainType.dangerPoint:
        return 'Danger Point';
      case MainType.recommendationPoint:
        return 'Recommendation Point';
      case MainType.safePoint:
        return 'Safe Point';
      default:
        return 'Danger Point';
    }
  }

  // enable only DangerPoint and RecommendationPoint for manual creation (without SafePoint)
  static List<bool> enabledCustomPoints = [
    true,
    true,
    false,
  ];
}

abstract class MapPoint {
  dynamic get type;

  int get colorR => 66;

  int get colorG => 133;

  int get colorB => 244;

  String get markerSrc;

  String get name;
}

enum DangerPoint implements MapPoint {
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
    return "Danger Point";
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

  // returns a name for the custom point of user
  @override
  String get name {
    switch (this) {
      case DangerPoint.lightPoint:
        return 'Dark Street';
      case DangerPoint.cleanlinessPoint:
        return 'Dirty Place';
      case DangerPoint.peoplePoint:
        return 'Dangerous People';
      case DangerPoint.animalsPoint:
        return 'Wild Animals';
      case DangerPoint.roadPoint:
        return 'Bad Road';
      case DangerPoint.childrenPoint:
        return 'Danger for Children';
      case DangerPoint.surroundingsPoint:
        return 'Uncomfortable Surroundings';
      case DangerPoint.otherPoint:
        return 'Other';
      default:
        return 'Other';
    }
  }

  // set custom markers for DangerPoints (differ from sub-type)
  @override
  String get markerSrc {
    switch (this) {
      case DangerPoint.lightPoint:
        return "lib/assets/marker/light_point_marker.png";
      case DangerPoint.cleanlinessPoint:
        return "lib/assets/marker/cleanliness_point_marker.png";
      case DangerPoint.peoplePoint:
        return "lib/assets/marker/people_point_marker.png";
      case DangerPoint.animalsPoint:
        return "lib/assets/marker/animals_point_marker.png";
      case DangerPoint.roadPoint:
        return "lib/assets/marker/road_point_marker.png";
      case DangerPoint.childrenPoint:
        return "lib/assets/marker/children_point_marker.png";
      case DangerPoint.surroundingsPoint:
        return "lib/assets/marker/surroundings_point_marker.png";
      case DangerPoint.otherPoint:
        return "lib/assets/marker/danger_point_marker.png";
      default:
        return "lib/assets/marker/danger_point_marker.png";
    }
  }
}

extension DangerPointDetails on DangerPoint {
  Icon get icon {
    return const Icon(Icons.dangerous, size: 50.0);
  }
}

enum RecommendationPoint implements MapPoint {
  intrusivePeople,
  culturalReligiousSpecifics,
  badTransport,
  attentionToBelongings,
  crowdedEvent,
  other;

  @override
  String get type {
    return "Recommendation Point";
  }

  @override
  int get colorR {
    return 244;
  }

  @override
  int get colorG {
    return 180;
  }

  @override
  int get colorB {
    return 0;
  }

  // returns a name for the custom point of user
  @override
  String get name {
    switch (this) {
      case RecommendationPoint.intrusivePeople:
        return 'Intrusive people';
      case RecommendationPoint.culturalReligiousSpecifics:
        return 'Cultural or religious specifics';
      case RecommendationPoint.badTransport:
        return 'Bad transport connections';
      case RecommendationPoint.attentionToBelongings:
        return 'Attention to your belongings';
      case RecommendationPoint.crowdedEvent:
        return 'Crowded event';
      case RecommendationPoint.other:
        return 'Other';
      default:
        return 'Other';
    }
  }

  @override
  String get markerSrc {
    switch (this) {
      case RecommendationPoint.intrusivePeople:
        return "lib/assets/marker/intrusive_people_point_marker.png";
      case RecommendationPoint.culturalReligiousSpecifics:
        return "lib/assets/marker/cultural_specifies_point_marker.png";
      case RecommendationPoint.badTransport:
        return "lib/assets/marker/bad_transport_point_marker.png";
      case RecommendationPoint.attentionToBelongings:
        return "lib/assets/marker/attention_belongings_point_marker.png";
      case RecommendationPoint.crowdedEvent:
        return "lib/assets/marker/crowd_point_marker.png";
      case RecommendationPoint.other:
        return "lib/assets/marker/information_point_marker.png";
      default:
        return "lib/assets/marker/information_point_marker.png";
    }
  }
}

extension RecommendationPointDetails on RecommendationPoint {
  Icon get icon {
    return const Icon(Icons.info, size: 50.0);
  }
}

// TODO: add another safe-points, possibly with own markers
enum SafePoint implements MapPoint {
  restaurant,
  police,
  grocery;

  @override
  String get type {
    return "Safe Point";
  }

  @override
  int get colorR => 15;

  @override
  int get colorG => 157;

  @override
  int get colorB => 88;

  // returns a name for the custom point of user
  @override
  String get name {
    switch (this) {
      case SafePoint.restaurant:
        return 'Restaurant';
      case SafePoint.grocery:
        return 'Grocery Store';
      case SafePoint.police:
        return 'Police Station';
      default:
        return 'Other';
    }
  }

  @override
  String get markerSrc => "lib/assets/marker/safe_point_marker.png";
}

extension SafePointDetails on SafePoint {
  Icon get icon {
    return const Icon(Icons.health_and_safety, size: 50.0);
  }
}
