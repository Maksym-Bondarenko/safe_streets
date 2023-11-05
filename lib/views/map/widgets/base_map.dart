import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BaseMap extends StatefulWidget {
  final void Function(GoogleMapController) setMapController;

  const BaseMap({
    Key? key,
    required this.setMapController,
  }) : super(key: key);

  @override
  State<BaseMap> createState() => _BaseMapState();
}

class _BaseMapState extends State<BaseMap> {
  final _customInfoWindowController = CustomInfoWindowController();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // Map settings
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
      // markers: Set<Marker>.from(currentlyActiveMarkers.union(pathMarkers)),
      // polylines: Set<Polyline>.of(polylines),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: true,
      trafficEnabled: false,
      mapToolbarEnabled: true,
      buildingsEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      // Callback when the map is created
      onMapCreated: (controller) {
        widget.setMapController(controller);
        _customInfoWindowController.googleMapController = controller;
      },
      // onMapCreated: widget.setMapController,
      // onMapCreated: (controller) {
      //   // widget.setMapController(controller);
      // },
      // onMapCreated: (controller) {
      //   setState(() {
      //     _googleMapController = controller;
      //     customInfoWindowController.googleMapController = _googleMapController;
      //   });
      //   // get the places with markers on the map
      //   // fetchPlaces();
      // },
      // // Callback when long-pressing on the map
      // onLongPress: (LatLng latLng) async {
      //   try {
      //     await showInformationDialog(latLng, context);
      //   } catch (e) {
      //     // Handle the exception
      //     print('Error: $e');
      //   }
      // },
      // // Callback when tapping on the map
      // onTap: (position) {
      //   customInfoWindowController.hideInfoWindow!();
      // },
      // // Callback when the camera is moved
      // onCameraMove: (position) {
      //   customInfoWindowController.onCameraMove!();
      // },
    );
  }
}

const _initialCameraPosition = CameraPosition(
  target: _munichCenter,
  zoom: 10.0,
  tilt: 0,
  bearing: 0,
);

const _munichCenter = LatLng(48.1351, 11.582);
