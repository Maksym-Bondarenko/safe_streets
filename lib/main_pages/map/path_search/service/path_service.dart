import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../../services/base_service.dart';
import '../models/response.dart';

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

  // returns a list of coordinates to build polylines
  // as in standard google maps walking path
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

  // returns the safest (AI-based) and fastest paths
  Future<Response?> getSafestAndFastestPath(
      double startLat,
      double startLon,
      double goalLat,
      double goalLon) async {

    final apiUrl = Uri.parse('https://routing-jua5hzcdma-vp.a.run.app/api/route?goal_lat=$goalLat&goal_lon=$goalLon&start_lat=$startLat&start_lon=$startLon');

    // TODO: add loading-spinner when getting the coordinates
    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        // Parse the response data
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Response routeResponse = Response.fromJson(responseData);

        return routeResponse;
      } else {
        // Handle errors or display a message
        print('Failed to fetch polylines. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error fetching polylines: $e');
    }

    return null;
  }

  // custom method for distance-calculation from the polyline coordinates
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
