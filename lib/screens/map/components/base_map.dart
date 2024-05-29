import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/screens/map/components/add_custom_point_dialog.dart';
import 'package:safe_streets/screens/map/providers/map_controller.dart';
import 'package:safe_streets/screens/map/providers/map_info_window_controller.dart';
import 'package:safe_streets/screens/map/providers/map_markers.dart';
import 'package:safe_streets/services/position.dart';

const _defaultCameraPosition = CameraPosition(target: LatLng(0, 0));

class BaseMap extends ConsumerWidget {
  const BaseMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(positionProvider);
    ref.watch(mapControllerProvider);
    final markers = ref.watch(mapMarkersProvider).valueOrNull ?? {};
    final mapInfoWindowControllerNotifier = ref.read(mapInfoWindowControllerProvider.notifier);
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
            ref.read(mapControllerProvider.notifier)
              ..set(controller)
              ..centerOnCurrentPosition();
          },
          onTap: (latLng) => mapInfoWindowControllerNotifier.closeInfoWindow(),
          onCameraMove: (position) => mapInfoWindowControllerNotifier.onCameraMove(),
          onLongPress: (latLng) => showDialog(context: context, builder: (context) => AddCustomPointDialog(latLng)),
        ),
      ],
    );
  }
}
