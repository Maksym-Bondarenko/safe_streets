import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/screens/map/hooks/custom_info_window_controller.dart';
import 'package:safe_streets/screens/map/components/add_custom_point_dialog.dart';
import 'package:safe_streets/screens/map/providers/map_controller.dart';
import 'package:safe_streets/screens/map/providers/map_markers.dart';
import 'package:safe_streets/services/position.dart';

const _defaultCameraPosition = CameraPosition(target: LatLng(0, 0));

class BaseMap extends HookConsumerWidget {
  const BaseMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('# bm - BUILD');
    final customInfoWindowController = useCustomInfoWindowController();
    // final mapControllerNotifier = ref.watch(mapControllerProvider.notifier);
    // mapControllerNotifier.setCustomInfoWindowController(customInfoWindowController);
    ref.watch(mapControllerProvider);
    ref.watch(positionProvider);
    final markers = ref.watch(mapMarkersProvider).valueOrNull ?? {};
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _defaultCameraPosition,
          markers: markers,
          // TODO implement routing path markers
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
          onMapCreated: (controller) {
            customInfoWindowController.googleMapController = controller;
            ref.read(mapControllerProvider.notifier)
              ..set(controller)
              ..centerOnCurrentPosition();
          },
          // onTap: (latLng) => mapControllerNotifier.closeInfoWindow(),
          // onCameraMove: (position) => mapControllerNotifier.onCameraMove(),
          onTap: (latLng) => customInfoWindowController.hideInfoWindow?.call(),
          onCameraMove: (position) => customInfoWindowController.onCameraMove?.call(),
          onLongPress: (latLng) => showDialog(context: context, builder: (context) => AddCustomPointDialog(latLng)),
        ),
        CustomInfoWindow(
          controller: customInfoWindowController,
          width: 300,
          height: 300,
          offset: kSpacingM,
        ),
      ],
    );
  }
}
