import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_filter.g.dart';

@riverpod
class MapFilter extends _$MapFilter {
  @override
  Set<MapFilterValue> build() {
    return {
      MapFilterValue.safePoints,
      MapFilterValue.recommendationPoints,
      MapFilterValue.dangerPoints,
    };
  }

  void toggleValue(MapFilterValue value) {
    state = state.contains(value) ? state.difference({value}) : state.union({value});
  }
}

enum MapFilterValue {
  safePoints,
  recommendationPoints,
  dangerPoints,
}
