import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../shared/global_functions.dart';
import 'notifications_service.dart';

/// Service for showing the notification when users approaches near to the point
class PointApproaching extends StatefulWidget {
  final GoogleMapController? googleMapController;
  final Set<Marker>? currentlyActiveMarkers;

  const PointApproaching(
      {super.key,
      required this.googleMapController,
      required this.currentlyActiveMarkers});

  @override
  State<PointApproaching> createState() => _PointApproaching();
}

class _PointApproaching extends State<PointApproaching> {
  bool areNotificationsEnabled = false;
  final NotificationsService notificationService = NotificationsService();
  // positionStream needs to be initialised, otherwise there is an error
  late StreamSubscription<Position>? positionStream = null;
  GoogleMapController? googleMapController;
  late Position _currentPosition;
  Set<Marker>? _currentlyActiveMarkers = {};
  // set radius of getting notified when approaching to the point to 50m
  final double _notificationRadius = 50.0;

  @override
  initState() {
    super.initState();
    googleMapController = widget.googleMapController;
    _currentlyActiveMarkers = widget.currentlyActiveMarkers;
    _getCurrentLocation();
    print(_currentlyActiveMarkers);
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
                accuracy: LocationAccuracy.best, distanceFilter: 0))
        .listen((Position position) {

      // TODO: check distance, if it is nearby -> create a Notification
      _loadNotification();
    });
  }

  // performs the showing of notification with given parameters on user's device
  void _loadNotification() async {
    // TODO: check if current location is near of some points (get them)
    await notificationService.showLocalNotification("Danger-point is nearby!",
        "Be careful, some point you turned notifications on is nearby!");

    for (var point in _currentlyActiveMarkers!) {
      print(point);
      // check the radius and TODO if point-notifications are enabled
      if (_isLocationWithinRadius(
          _currentPosition, point.position, _notificationRadius)) {
        // show notification with point-info
        String title = "${point.infoWindow.toString()}";
        String description = "${point.toString()}";
        await notificationService.showLocalNotification(title, description);
      }
    }
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

                  print(_currentlyActiveMarkers);

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
