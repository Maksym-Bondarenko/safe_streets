import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/widgets/filled_icon_button.dart';

class MapControlButtons extends StatelessWidget {
  final GoogleMapController? _googleMapController;
  final void Function(Position) _onUpdateCurrentLocation;

  const MapControlButtons({
    super.key,
    GoogleMapController? googleMapController,
    required void Function(Position) onUpdateCurrentLocation,
  })  : _googleMapController = googleMapController,
        _onUpdateCurrentLocation = onUpdateCurrentLocation;

  @override
  Widget build(context) {
    return Column(
      children: <Widget>[
        FilledIconButton(
          onPressed: _zoomIn,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: kSpacingM),
        FilledIconButton(
          onPressed: _zoomOut,
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(height: kSpacingM),
        FilledIconButton(
          onPressed: _centerOnCurrentLocation,
          icon: const Icon(Icons.my_location),
        ),
      ],
    );
  }

  void _zoomIn() {
    _googleMapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _googleMapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _centerOnCurrentLocation() async {
    try {
      Position currentPosition = await getCurrentLocation(_googleMapController);

      _googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
            zoom: 18.0,
          ),
        ),
      );
      _onUpdateCurrentLocation(currentPosition);
    } catch (e) {
      print(e);
    }
  }
}
