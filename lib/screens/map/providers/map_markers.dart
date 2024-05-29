import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/models/point.dart';
import 'package:safe_streets/screens/map/providers/map_filter.dart';
import 'package:safe_streets/screens/map/providers/map_points.dart';
import 'package:safe_streets/screens/map/providers/map_search.dart';
import 'package:safe_streets/screens/map/providers/selected_place.dart';
import 'package:safe_streets/utils/assets.dart';

part 'map_markers.g.dart';

@riverpod
Future<Set<Marker>> mapMarkers(MapMarkersRef ref) async {
  final points = await ref.watch(filteredMarkerPointsProvider.future);
  final pointIcons = await Future.wait(
    points.map((point) => getBytesFromAsset(point.type.markerImagePath, kSizeMarkerIcon)),
  );
  final markers = <Marker>[];
  for (final (index, point) in points.indexed) {
    final Point(:name, :type, :latitude, :longitude) = point;
    final iconBytes = pointIcons[index];
    final icon = iconBytes != null
        ? BitmapDescriptor.fromBytes(iconBytes)
        : BitmapDescriptor.defaultMarkerWithHue(HSLColor.fromColor(type.color).hue);
    markers.add(Marker(
      markerId: MarkerId('${type.mainType}-${type.subType}-$latitude-$longitude-$name'),
      position: LatLng(latitude, longitude),
      icon: icon,
      onTap: () {
        final place = Place(
          displayName: TextData(text: name),
          location: Location(latitude: latitude, longitude: longitude),
        );
        ref.read(selectedPlaceProvider.notifier).set(place);
        // TODO enable custom info window
        // customInfoWindowController.addInfoWindow?.call(
        //   PointInfoWindow(point: point),
        //   LatLng(point.latitude, point.longitude),
        // );
      },
    ));
  }
  final searchResults = await ref.watch(mapSearchResultsProvider.future);
  for (final place in searchResults) {
    final Location(:latitude, :longitude) = place.location;
    markers.add(Marker(
      markerId: MarkerId('$latitude,$longitude'),
      position: LatLng(latitude, longitude),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        ref.read(selectedPlaceProvider.notifier).set(place);
      },
    ));
  }
  return markers.toSet();
}

@riverpod
Future<Iterable<Point>> filteredMarkerPoints(FilteredMarkerPointsRef ref) async {
  final points = await ref.watch(mapPointsProvider.future);
  final mapFilterValues = ref.watch(mapFilterProvider);
  return points.where((point) => switch (point.type) {
        PointType type when type is SafePointType => mapFilterValues.contains(MapFilterValue.safePoints),
        PointType type when type is RecommendationPointType =>
          mapFilterValues.contains(MapFilterValue.recommendationPoints),
        PointType type when type is DangerPointType => mapFilterValues.contains(MapFilterValue.dangerPoints),
        _ => false,
      });
}
