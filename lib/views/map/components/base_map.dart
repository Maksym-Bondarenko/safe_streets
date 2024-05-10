import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_streets/constants.dart';
import 'package:safe_streets/models/point.dart';

import 'package:safe_streets/utils/assets.dart';
import 'package:safe_streets/views/map/components/add_custom_point_dialog.dart';
import 'package:safe_streets/views/map/providers/map_controller.dart';
import 'package:safe_streets/views/map/providers/map_markers.dart';
import 'package:safe_streets/widgets/point_info_window.dart';

class BaseMap extends ConsumerStatefulWidget {
  const BaseMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseMapState();
}

class _BaseMapState extends ConsumerState<BaseMap> {
  final _customInfoWindowController = CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final filteredMarkerPoints = ref.watch(filteredMarkerPointsProvider);
    final markers = filteredMarkerPoints.whenData(_buildMarkers);
    return FutureBuilder(
      future: markers.value,
      builder: (context, snapshot) {
        final mapControl = ref.read(mapControllerProvider.notifier);
        return Stack(
          children: [
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _defaultCameraPosition,
                markers: snapshot.data?.toSet() ?? {},
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
                  _customInfoWindowController.googleMapController = controller;
                  mapControl.setController(controller);
                  mapControl.centerOnCurrentPosition(zoom: 14);
                },
                onLongPress: (latLng) => showDialog(
                      context: context,
                      builder: (context) => AddCustomPointDialog(latLng),
                    ),
                onTap: (latLng) {
                  _customInfoWindowController.hideInfoWindow?.call();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove?.call();
                }),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              width: 300,
              height: 300,
              offset: kSpacingM,
            ),
          ],
        );
      },
    );
  }

  Future<List<Marker>> _buildMarkers(Iterable<Point> points) async {
    return Future.wait(points.map((point) async {
      final iconBytes = await getBytesFromAsset(
        point.type.markerImagePath,
        kMarkerIcon.toInt(),
      );
      final icon = iconBytes != null
          ? BitmapDescriptor.fromBytes(iconBytes)
          : BitmapDescriptor.defaultMarkerWithHue(HSLColor.fromColor(point.type.color).hue);

      return Marker(
        markerId: MarkerId(
          '${point.type.mainType}-${point.type.subType}-${point.latitude}-${point.longitude}-${point.name}',
        ),
        position: LatLng(point.latitude, point.longitude),
        icon: icon,
        onTap: () {
          _customInfoWindowController.addInfoWindow?.call(
            PointInfoWindow(point: point),
            LatLng(point.latitude, point.longitude),
          );
        },
      );
    }));
  }
}

const _defaultCameraPosition = CameraPosition(target: LatLng(0, 0));
