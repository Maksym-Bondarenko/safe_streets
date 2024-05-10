import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/point.dart';
import 'package:safe_streets/screens/map/providers/map_filter.dart';
import 'package:safe_streets/screens/map/providers/map_points.dart';

part 'map_markers.g.dart';

@riverpod
Future<Iterable<Point>> filteredMarkerPoints(FilteredMarkerPointsRef ref) async {
  final points = await ref.watch(mapPointsProvider.future);
  final mapFilterValues = ref.watch(mapFilterProvider);
  return points.where((point) => switch (point.type) {
        PointType type when type is SafePointType => mapFilterValues.contains(MapFilterValue.safePoints),
        PointType type when type is RecommendationPointType =>
          mapFilterValues.contains(MapFilterValue.recommendationPoints),
        PointType type when type is DangerPointType => mapFilterValues.contains(MapFilterValue.dangerPoints),
        _ => false,
      });
}
