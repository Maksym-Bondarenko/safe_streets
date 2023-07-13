import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'base_service.dart';

/// Service for building a path between two geopoints via Google API
class PathService extends BaseService {

  // Calculating to check that the position relative
  // to the frame, and pan & zoom the camera accordingly.
  List<double> getCameraCoordinates(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude) {
    double miny = (startLatitude <= destinationLatitude)
        ? startLatitude
        : destinationLatitude;
    double minx = (startLongitude <= destinationLongitude)
        ? startLongitude
        : destinationLongitude;
    double maxy = (startLatitude <= destinationLatitude)
        ? destinationLatitude
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude)
        ? destinationLongitude
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    Set<double> result = {};
    result.add(southWestLatitude);
    result.add(southWestLongitude);
    result.add(northEastLatitude);
    result.add(northEastLongitude);

    return result.toList();
  }

  Future<List<LatLng>> getPolylineCoordinates(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
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

    return polylineCoordinates;
  }

  double calculateDistance(List<LatLng> polylineCoordinates) {
    double totalDistance = 0.0;

    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    return totalDistance;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double coordinateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Calculating the distance between the start and the end positions
  // with a straight path, without considering any route
  Future<double> calculateDirectDistanceInMeters(startLatitude, startLongitude,
      destinationLatitude, destinationLongitude) async {
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
