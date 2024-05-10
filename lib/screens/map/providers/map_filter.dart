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

  // final places = await GeocodingPlatform.instance
  //     .placemarkFromAddress(query)
  //     .catchError((e) => print(e));

  // if (places == null || places.isEmpty) {
  //   return;
  // }

  // final place = places[0];

  // _controller?.animateCamera(
  //   CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //       target: LatLng(place.position.latitude, place.position.longitude),
  //       zoom: 18.0,
  //     ),
  //   ),
  // );
}

enum MapFilterValue {
  safePoints,
  recommendationPoints,
  dangerPoints,
}
