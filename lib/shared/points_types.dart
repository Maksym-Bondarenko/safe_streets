import 'package:flutter/material.dart';

/// Functions for working with three types of points (Safe, Danger, Recommendation)

// Enum representing the three main Point types
enum MainType {
  dangerPoint,
  recommendationPoint,
  safePoint;
}

// Extension on MainType to provide additional details
extension MainTypeDetails on MainType {
  String get name {
    // Return the name corresponding to the MainType value
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
}

// get the main-type of the point by name
MainType getMainType(String mainType) {
  switch (mainType) {
    case "Danger Point":
      return MainType.dangerPoint;
    case "Recommendation Point":
      return MainType.recommendationPoint;
    case "Safe Point":
      return MainType.safePoint;
    default:
      return MainType.dangerPoint;
  }
}

// get main-type by the name in id
// (e.g. for pointApproaching where type is encoded as string within pointId)
MainType getMainTypeFromString(String mainType) {
  switch (mainType) {
    case "MainType.dangerPoint":
      return MainType.dangerPoint;
    case "MainType.recommendationPoint":
      return MainType.recommendationPoint;
    case "MainType.safePoint":
      return MainType.safePoint;
    default:
      return MainType.dangerPoint;
  }
}

// get the sub-type of the point by name
MapPoint getSubType(String subType, String mainType) {
  switch (subType) {
    // Danger Points
    case "Dark Street":
      return DangerPoint.lightPoint;
    case "Dirty Place":
      return DangerPoint.cleanlinessPoint;
    case "Dangerous People":
      return DangerPoint.peoplePoint;
    case "Wild Animals":
      return DangerPoint.animalsPoint;
    case "Bad Road":
      return DangerPoint.roadPoint;
    case "Danger for Children":
      return DangerPoint.childrenPoint;
    case "Uncomfortable Surroundings":
      return DangerPoint.surroundingsPoint;

    // Recommendation Points
    case "Intrusive people":
      return RecommendationPoint.intrusivePeople;
    case "Cultural or religious specifics":
      return RecommendationPoint.culturalReligiousSpecifics;
    case "Bad transport connections":
      return RecommendationPoint.badTransport;
    case "Attention to your belongings":
      return RecommendationPoint.attentionToBelongings;
    case "Crowded event":
      return RecommendationPoint.crowdedEvent;

    // Safe Points
    case "Police Station":
      return SafePoint.police;
    case "Restaurant":
      return SafePoint.restaurant;
    case "Grocery Store":
      return SafePoint.grocery;

    case "Other":
      if (mainType == "Danger Point") {
        return DangerPoint.other;
      }
      return RecommendationPoint.other;
    default:
      return DangerPoint.other;
  }
}

// get sub-type by the name in id
// (e.g. for pointApproaching where subtype is encoded as string within pointId)
MapPoint getSubTypeFromString(String subType, String mainType) {
  switch (subType) {
    // Danger Points
    case "DangerPoint.lightPoint":
      return DangerPoint.lightPoint;
    case "DangerPoint.cleanlinessPoint":
      return DangerPoint.cleanlinessPoint;
    case "DangerPoint.peoplePoint":
      return DangerPoint.peoplePoint;
    case "DangerPoint.animalsPoint":
      return DangerPoint.animalsPoint;
    case "DangerPoint.roadPoint":
      return DangerPoint.roadPoint;
    case "DangerPoint.childrenPoint":
      return DangerPoint.childrenPoint;
    case "DangerPoint.surroundingsPoint":
      return DangerPoint.surroundingsPoint;
    case "DangerPoint.other":
      return DangerPoint.other;

    // Recommendation Points
    case "RecommendationPoint.intrusivePeople":
      return RecommendationPoint.intrusivePeople;
    case "RecommendationPoint.culturalReligiousSpecifics":
      return RecommendationPoint.culturalReligiousSpecifics;
    case "RecommendationPoint.badTransport":
      return RecommendationPoint.badTransport;
    case "RecommendationPoint.attentionToBelongings":
      return RecommendationPoint.attentionToBelongings;
    case "RecommendationPoint.crowdedEvent":
      return RecommendationPoint.crowdedEvent;

    // Safe Points
    case "SafePoint.restaurant":
      return SafePoint.restaurant;
    case "SafePoint.police":
      return SafePoint.police;
    case "SafePoint.grocery":
      return SafePoint.grocery;

    // Other types
    default:
      if (mainType == "MainType.dangerPoint") {
        return DangerPoint.other;
      }
      return RecommendationPoint.other;
  }
}

// Abstract class representing a MapPoint
abstract class MapPoint {
  dynamic get type;

  // Default color values for MapPoints
  int get colorR => 66;
  int get colorG => 133;
  int get colorB => 244;

  // Marker source for the MapPoint
  String get markerSrc;
  // Name of the MapPoint
  String get name;
}

// Enum representing DangerPoint subtypes
enum DangerPoint implements MapPoint {
  lightPoint,
  cleanlinessPoint,
  peoplePoint,
  animalsPoint,
  roadPoint,
  childrenPoint,
  surroundingsPoint,
  other;

  @override
  String get type {
    return "Danger Point";
  }

  // Custom color values (red) for DangerPoints
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

  // Returns the name for the DangerPoint subtype
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
      case DangerPoint.other:
        return 'Other';
      default:
        return 'Other';
    }
  }

  // Returns the marker source for the DangerPoint subtype
  @override
  String get markerSrc {
    switch (this) {
      case DangerPoint.lightPoint:
        return "lib/assets/markers/danger_points/light_point_marker.png";
      case DangerPoint.cleanlinessPoint:
        return "lib/assets/markers/danger_points/cleanliness_point_marker.png";
      case DangerPoint.peoplePoint:
        return "lib/assets/markers/danger_points/people_point_marker.png";
      case DangerPoint.animalsPoint:
        return "lib/assets/markers/danger_points/animals_point_marker.png";
      case DangerPoint.roadPoint:
        return "lib/assets/markers/danger_points/road_point_marker.png";
      case DangerPoint.childrenPoint:
        return "lib/assets/markers/danger_points/children_point_marker.png";
      case DangerPoint.surroundingsPoint:
        return "lib/assets/markers/danger_points/surroundings_point_marker.png";
      case DangerPoint.other:
        return "lib/assets/markers/danger_points/danger_point_marker.png";
      default:
        return "lib/assets/markers/danger_points/danger_point_marker.png";
    }
  }
}

// Extension on DangerPoint to provide additional details (icon)
extension DangerPointDetails on DangerPoint {
  Icon get icon {
    return const Icon(Icons.dangerous, size: 50.0);
  }
}

// Enum representing RecommendationPoint subtypes
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

  // Custom color values (yellow) for DangerPoints
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

  // Returns the name for the RecommendationPoint subtype
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

  // Returns the marker source for the RecommendationPoint subtype
  @override
  String get markerSrc {
    switch (this) {
      case RecommendationPoint.intrusivePeople:
        return "lib/assets/markers/recommendation_points/intrusive_people_point_marker.png";
      case RecommendationPoint.culturalReligiousSpecifics:
        return "lib/assets/markers/recommendation_points/cultural_specifies_point_marker.png";
      case RecommendationPoint.badTransport:
        return "lib/assets/markers/recommendation_points/bad_transport_point_marker.png";
      case RecommendationPoint.attentionToBelongings:
        return "lib/assets/markers/recommendation_points/attention_belongings_point_marker.png";
      case RecommendationPoint.crowdedEvent:
        return "lib/assets/markers/recommendation_points/crowd_point_marker.png";
      case RecommendationPoint.other:
        return "lib/assets/markers/recommendation_points/information_point_marker.png";
      default:
        return "lib/assets/markers/recommendation_points/information_point_marker.png";
    }
  }
}

// Extension on RecommendationPoint to provide additional details (icon)
extension RecommendationPointDetails on RecommendationPoint {
  Icon get icon {
    return const Icon(Icons.info, size: 50.0);
  }
}

// TODO: add another safe-points, possibly with own markers
// Enum representing SafePoint subtypes
enum SafePoint implements MapPoint {
  restaurant,
  police,
  grocery;

  @override
  String get type {
    return "Safe Point";
  }

  // Custom color values (green) for DangerPoints
  @override
  int get colorR => 15;

  @override
  int get colorG => 157;

  @override
  int get colorB => 88;

  // Returns the name for the SafePoint subtype
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

  // Returns the marker source for the SafePoint subtype
  @override
  String get markerSrc => "lib/assets/markers/safe_points/safe_point_marker.png";
}

// Extension on SafePoint to provide additional details (icon)
extension SafePointDetails on SafePoint {
  Icon get icon {
    return const Icon(Icons.health_and_safety, size: 50.0);
  }
}

// ****************************************************************************
// Enum representing the Voting types on the point
enum Voting {
  upvote,
  devote;
}