import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:safe_streets/constants.dart';

part 'point.freezed.dart';
part 'point.g.dart';

@freezed
class Point with _$Point {
  const factory Point({
    @PointTypeConverter() required PointType type,
    required double latitude,
    required double longitude,
    required String name,
    String? description,
  }) = _Point;

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);
}

sealed class PointType {
  static const List<PointType> values = [
    ...DangerPointType.values,
    ...RecommendationPointType.values,
    ...SafePointType.values,
  ];

  String get subType;
  String get mainType;
  String get markerImagePath;
  Color get color;
  IconData get icon;
}

class PointTypeConverter implements JsonConverter<PointType, String> {
  const PointTypeConverter();

  @override
  String toJson(PointType pointType) => pointType.subType;

  @override
  PointType fromJson(String subType) => PointType.values.firstWhere(
        (pointType) => pointType.subType == subType,
      );
}

@JsonEnum(valueField: 'subType')
enum DangerPointType implements PointType {
  light(subType: 'Dark Street', markerImagePath: '$_basePath/light_point_marker.png'),
  cleanliness(subType: 'Dirty Place', markerImagePath: '$_basePath/cleanliness_point_marker.png'),
  people(subType: 'Dangerous People', markerImagePath: '$_basePath/people_point_marker.png'),
  animals(subType: 'Wild Animals', markerImagePath: '$_basePath/animals_point_marker.png'),
  road(subType: 'Bad Road', markerImagePath: '$_basePath/road_point_marker.png'),
  children(subType: 'Danger for Children', markerImagePath: '$_basePath/children_point_marker.png'),
  surroundings(subType: 'Uncomfortable Surroundings', markerImagePath: '$_basePath/surroundings_point_marker.png'),
  other(subType: 'Other', markerImagePath: '$_basePath/danger_point_marker.png');

  const DangerPointType({
    required this.subType,
    required this.markerImagePath,
  });

  static const _basePath = 'assets/markers/danger_points';

  @override
  final Color color = kColorDanger;
  @override
  final IconData icon = Icons.dangerous;
  @override
  final String mainType = 'Danger point';
  @override
  final String subType;
  @override
  final String markerImagePath;
}

@JsonEnum(valueField: 'subType')
enum RecommendationPointType implements PointType {
  intrusivePeople(subType: 'Intrusive people', markerImagePath: '$_basePath/intrusive_people_point_marker.png'),
  culturalReligiousSpecifics(
      subType: 'Cultural or religious specifics', markerImagePath: '$_basePath/cultural_specifies_point_marker.png'),
  badTransport(subType: 'Bad transport connections', markerImagePath: '$_basePath/bad_transport_point_marker.png'),
  attentionToBelongings(
      subType: 'Attention to your belongings', markerImagePath: '$_basePath/attention_belongings_point_marker.png'),
  crowdedEvent(subType: 'Crowded event', markerImagePath: '$_basePath/crowd_point_marker.png'),
  other(subType: 'Other', markerImagePath: '$_basePath/information_point_marker.png');

  const RecommendationPointType({
    required this.subType,
    required this.markerImagePath,
  });

  static const _basePath = 'assets/markers/recommendation_points';

  @override
  final Color color = kColorRecommendation;
  @override
  final IconData icon = Icons.info;
  @override
  final String mainType = 'Recommendation point';
  @override
  final String subType;
  @override
  final String markerImagePath;
}

// TODO: add other safe-points, possibly with own markers
@JsonEnum(valueField: 'subType')
enum SafePointType implements PointType {
  restaurant(subType: 'Restaurant', markerImagePath: '$_basePath/safe_point_marker.png'),
  police(subType: 'Police Station', markerImagePath: '$_basePath/safe_point_marker.png'),
  grocery(subType: 'Grocery Store', markerImagePath: '$_basePath/safe_point_marker.png'),
  other(subType: 'Other', markerImagePath: '$_basePath/safe_point_marker.png');

  const SafePointType({
    required this.subType,
    required this.markerImagePath,
  });

  static const _basePath = 'assets/markers/safe_points';

  @override
  final Color color = kColorSafe;
  @override
  final IconData icon = Icons.health_and_safety;
  @override
  final String mainType = 'Safe point';
  @override
  final String subType;
  @override
  final String markerImagePath;
}
