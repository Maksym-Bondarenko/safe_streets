import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/services/base.dart';

/// Service for building a path between two geopoints via Google API
class PathService extends BaseService {
  // TODO: replace some functionality in pathSearch.dart with this service
  Future<List<LatLng>> calculatePath(String startAddress, String destinationAddress) async {
    List<LatLng> polylineCoordinates = [];

    try {
      List<Location> startPlacemark = await locationFromAddress(startAddress);
      List<Location> destinationPlacemark = await locationFromAddress(destinationAddress);

      double startLatitude = startPlacemark[0].latitude;
      double startLongitude = startPlacemark[0].longitude;
      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        apiKey!,
        PointLatLng(startLatitude, startLongitude),
        PointLatLng(destinationLatitude, destinationLongitude),
        travelMode: TravelMode.walking,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
    } catch (e) {
      print(e);
    }

    return polylineCoordinates;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double coordinateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Calculating the distance between the start and the end positions
  // with a straight path, without considering any route
  Future<double> calculateDirectDistanceInMeters(
      startLatitude, startLongitude, destinationLatitude, destinationLongitude) async {
    double distanceInMeters = Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      destinationLatitude,
      destinationLongitude,
    );
    print('Distance in meters: $distanceInMeters');
    return distanceInMeters;
  }
}
