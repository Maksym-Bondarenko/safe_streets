import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../shared/app_state.dart';
import '../shared/global_functions.dart';
import '../shared/points_types.dart';
import 'notifications_service.dart';

/// Service for showing the notification when users approaches near to the point
class PointApproaching extends StatefulWidget {
  const PointApproaching({super.key});

  @override
  State<PointApproaching> createState() => _PointApproaching();
}

class _PointApproaching extends State<PointApproaching> {
  bool areNotificationsEnabled = false;
  final NotificationsService notificationService = NotificationsService();

  // positionStream needs to be initialised, otherwise there is an error
  late StreamSubscription<Position>? positionStream = null;
  GoogleMapController? googleMapController;
  late AppState appState;
  late Position _currentPosition;
  Set<Marker>? _currentlyActiveMarkers = {};

  // set radius of getting notified when approaching to the point to 50m
  final double _notificationRadius = 50.0;

  @override
  initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
    googleMapController = appState.controller;
    _currentlyActiveMarkers = appState.activeMarkers;
    _getCurrentLocation();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await getCurrentLocation(googleMapController);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  // initial start point of the service
  Future<void> startService() async {
    bool arePermissionsGranted = await notificationService.checkPermissions();

    if (arePermissionsGranted) {
      // init the notifications with platform-specific settings
      await notificationService.initializeNotifications();
      // start searching for points near the user
      _startLocationUpdates();
    }
  }

  // starts getting user's location and by its change checking which points are within the near-radius
  void _startLocationUpdates() {
    // Set up the location change subscription
    positionStream = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.best, distanceFilter: 10))
        .listen((Position position) {
      // update active markers from appState
      _currentlyActiveMarkers = appState.activeMarkers;
      // check all active markers
      for (var point in _currentlyActiveMarkers!) {
        // check the radius and TODO if point-notifications are enabled
        if (_isLocationWithinRadius(
            _currentPosition, point.position, _notificationRadius)) {
          _loadNotification(point);
        }
      }
    });
  }

  // performs the showing of notification with given parameters on user's device
  void _loadNotification(Marker point) async {
    // MainType.dangerPoint-DangerPoint.lightPoint-48.258038049510475-11.657517068088055-test
    final String pointId = point.markerId.value;

    // Find the index of the first dash character '-'
    int typeIndex = pointId.indexOf('-');
    final String pointTypeString = pointId.substring(0, typeIndex);
    final MainType pointType = getMainTypeFromString(pointTypeString);

    // Find the index of the second dash character '-' starting from the position after the first dash
    int subTypeIndex = pointId.indexOf('-', typeIndex + 1);
    final String pointSubTypeString =
        pointId.substring(typeIndex + 1, subTypeIndex);
    final MapPoint pointSubType = getSubTypeFromString(pointSubTypeString, pointSubTypeString);

    // Find the index of the last dash character '-'
    int titleIndex = pointId.lastIndexOf('-');

    final String pointTitle = pointId.substring(titleIndex + 1);

    await notificationService.showLocalNotification(
        "${pointType.name} is nearby!",
        "Be careful, some point (${pointSubType.name}) with title '$pointTitle' is nearby!");
  }

  // check if the given location near the given point (with lat and lng) in a given radius
  bool _isLocationWithinRadius(Position location, LatLng point, double radius) {
    const double earthRadius = 6371000; // in meters

    double lat1 = location.latitude;
    double lon1 = location.longitude;
    double lat2 = point.latitude;
    double lon2 = point.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    double distance = earthRadius * c;

    return distance <= radius;
  }

  // transforms degrees to the radians (for calculating distance to the point)
  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.purple.shade200,
        child: InkWell(
          splashColor: Colors.purple, // inkwell color
          child: SizedBox(
            width: 50,
            height: 50,
            child: (areNotificationsEnabled)
                ? const Icon(Icons.notifications_on)
                : const Icon(Icons.notifications_off),
          ),
          onTap: () {
            if (areNotificationsEnabled) {
              // disable notifications
              setState(() {
                areNotificationsEnabled = false;
              });
              // stop receiving location updates
              positionStream?.cancel();
            } else {
              // enable notifications
              setState(() {
                areNotificationsEnabled = true;
              });
              // start notifications services for continuous tracking and notifications
              startService();
            }
          },
        ),
      ),
    );
  }
}
