import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/screens/map/providers/selected_place.dart';
import 'package:safe_streets/services/position.dart';
import 'package:safe_streets/utils/set_provider.dart';

part 'map_controller.g.dart';

const _defaultBoundsPadding = 60.0;
const _defaultZoom = 16.0;

@riverpod
class MapController extends _$MapController with SetProvider {
  @override
  // GoogleMapController? build() => null;
  GoogleMapController? build() {
    print('BUILD MapController');
    ref.onCancel(() {
      print('onCANCEL MapController');
    });
    ref.onDispose(() {
      print('onDISPOSE MapController');
    });
    ref.onResume(() {
      print('onRESUME MapController');
    });
    return null;
  }

  Future<void> zoomIn() async {
    print('ZOOM IN $state');
    await state?.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> zoomOut() async {
    print('ZOOM OUT $state');
    await state?.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> centerOnPosition({required double latitude, required double longitude, double? zoom}) async {
    print('CENTER ON POSITION $latitude, $longitude, $zoom');
    await state?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: zoom ?? _defaultZoom,
        ),
      ),
    );
  }

  Future<void> centerOnCurrentPosition({double? zoom}) async {
    final Position(:latitude, :longitude) = await ref.watch(positionProvider.future);
    print('center on current position: $latitude, $longitude');
    await centerOnPosition(latitude: latitude, longitude: longitude, zoom: zoom);
  }

  Future<void> centerOnSelectedPlace({double? zoom}) async {
    final place = await ref.read(selectedPlaceProvider.future);
    final Location(:latitude, :longitude) = place.location;
    await centerOnPosition(latitude: latitude, longitude: longitude, zoom: zoom);
  }

  Future<void> centerOnBounds(LatLngBounds bounds) async {
    await state?.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        _defaultBoundsPadding,
      ),
    );
  }
}
