import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/point.dart';
import 'package:safe_streets/screens/common/components/point_info_window.dart';

part 'map_info_window_controller.g.dart';

@riverpod
class MapInfoWindowController extends _$MapInfoWindowController {
  @override
  CustomInfoWindowController build() => CustomInfoWindowController();

  void showPointInfoWindow(Point point) {
    state.addInfoWindow?.call(
      PointInfoWindow(point: point),
      LatLng(point.latitude, point.longitude),
    );
  }

  void closeInfoWindow() => state.hideInfoWindow?.call();

  void onCameraMove() => state..onCameraMove?.call();

  void setGoogleMapController(GoogleMapController googleMapController) {
    state.googleMapController = googleMapController;
  }
}
