import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/services/position.dart';

part 'map_controller.g.dart';

const _defaultZoom = 18.0;

@riverpod
class MapController extends _$MapController {
  // final Completer<GoogleMapController> _controller = Completer();

  // TODO fix map controller handover
  GoogleMapController? _controller;

  // get controller

  @override
  void build() {}

  void setController(GoogleMapController controller) {
    _controller = controller;
    // _controller.complete(controller);
  }

  Future<void> zoomIn() async {
    // final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(CameraUpdate.zoomIn());
    await _controller?.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> zoomOut() async {
    // final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(CameraUpdate.zoomOut());
    await _controller?.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> centerOn({required double latitude, required double longitude, double? zoom}) async {
    print('## m - centering on $latitude, $longitude, $zoom');
    // final GoogleMapController controller = await _controller.future;
    // print('_controller: ${controller != null}');
    print('## _controller: ${_controller}');
    // print('_controller: ${controller}');
    // await controller.animateCamera(
    await _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: zoom ?? _defaultZoom,
        ),
      ),
    );
  }

  Future<void> centerOnCurrentPosition({double? zoom}) async {
    final Position(:latitude, :longitude) = await ref.read(positionProvider.future);
    await centerOn(latitude: latitude, longitude: longitude, zoom: zoom);
  }
}
