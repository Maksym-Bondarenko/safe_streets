import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/models/places.dart';

LatLngBounds getLatLngBoundsOfPlaces(Iterable<Place> places) {
  double maxLat = double.negativeInfinity;
  double minLat = double.infinity;
  double maxLng = double.negativeInfinity;
  double minLng = double.infinity;

  for (final place in places) {
    final Location(:latitude, :longitude) = place.location;
    if (latitude > maxLat) maxLat = latitude;
    if (latitude < minLat) minLat = latitude;
    if (longitude > maxLng) maxLng = longitude;
    if (longitude < minLng) minLng = longitude;
  }

  return LatLngBounds(
    southwest: LatLng(minLat, minLng),
    northeast: LatLng(maxLat, maxLng),
  );
}
