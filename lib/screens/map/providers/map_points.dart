import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/point.dart';
import 'package:safe_streets/services/safety.dart';

part 'map_points.g.dart';

@riverpod
Future<List<Point>> mapPoints(MapPointsRef ref) async {
  return await ref.watch(safetyServiceProvider.future);
}
