import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../shared/global_functions.dart';
import '../ui/dialog/dialog_window.dart';

import '../ui/infowindow/point_infowindow.dart';
import '../shared/points_types.dart';

/// Main Page with the FilterMarkers-Map, including 3 types of Points
class FilterMap extends StatefulWidget {
  const FilterMap({super.key});

  @override
  State<StatefulWidget> createState() => _FilterMap();
}

class _FilterMap extends State<FilterMap> {

  BitmapDescriptor safeMarkerIcon = BitmapDescriptor.defaultMarker;

  static const LatLng _kMapMunichCenter = LatLng(48.1351, 11.582);

  static const CameraPosition _kInitialPosition = CameraPosition(
      target: _kMapMunichCenter, zoom: 10.0, tilt: 0, bearing: 0);

  final CustomInfoWindowController customInfoWindowController =
  CustomInfoWindowController();

  final Completer<GoogleMapController> _googleMapController = Completer();

  Set<Marker> currentlyActiveMarkers = {};
  Set<Marker> dangerPointsMarkers = {};
  Set<Marker> safePointsMarkers = {};
  Set<Marker> recommendationPointsMarkers = {};

  final Map<String, Marker> _policeMarkers = {};
  final Set<Marker> _dangerPointsMarkers = {};
  final Set<Marker> _safePointsMarkers = {};
  final Set<Marker> _recommendationPointsMarkers = {};

  // initial filters (danger-points, safe-points and tourists-points)
  final List<bool> _selectedFilters = <bool>[false, false, false];

  // visual of ToggleButtons
  static const List<Widget> filters = <Widget>[
    Icon(Icons.notification_important),
    Icon(Icons.question_mark),
    Icon(Icons.handshake),
  ];

  @override
  initState() {
    super.initState();
    updatePointsVisibility();
  }

  // fetch data from DB with corresponding sub-type and show them on the map
  Future<void> _onMapCreated(GoogleMapController controller) async {
    // set up controllers
    _googleMapController.complete(controller);
    customInfoWindowController.googleMapController = controller;

    getBytesFromAsset('lib/assets/markers/safe_points/safe_point_marker.png', 200)
        .then((onValue) {
      safeMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    // fetch safePoints (police stations) and custom points (DangerPoint and RecommendationPoint)
    var policeStations = [];
    const munichCenterLat = 48.1351;
    const munichCenterLong = 11.582;
    // TODO: Add your Google Maps API key here
    String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    try {
      final response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/search/json?location=${munichCenterLat},${munichCenterLong}8&rankby=distance&types=police&sensor=false&key=${apiKey}"));
      policeStations = json.decode(response.body)["results"];
    } catch (e) {
      print(e);
    }

    var host = "34.159.7.34";
    // TODO: uncomment following line for testing with local server
    host = "localhost";
    var points = [];
    try {
      final response = await http.get(Uri.parse("http://${host}:8080/get/all_places"));
      if (response.statusCode == 200) {
        points = json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }

    // clear all markers
    setState(() {
      _policeMarkers.clear();
      _dangerPointsMarkers.clear();
      _safePointsMarkers.clear();
      _recommendationPointsMarkers.clear();
    });

    for (final policeStation in policeStations) {
      var id = policeStation["place_id"];
      var latitude = policeStation["geometry"]["location"]["lat"];
      var longitude = policeStation["geometry"]["location"]["lng"];
      var address = policeStation["vicinity"];
      var name = policeStation["name"];
      print(
          "NAME ${name} ADDRESS ${address} lat ${latitude} long ${longitude}");
      final marker = Marker(
          markerId: MarkerId(id),
          position: LatLng(latitude, longitude),
          icon: safeMarkerIcon,
          onTap: () =>
          {
            customInfoWindowController.addInfoWindow!(
                PointInfoWindow(
                    mainType: MainType.safePoint,
                    subType: SafePoint.police,
                    title: name,
                    description: "Address: ${address}",
                    votes: 0),
                LatLng(latitude, longitude))
          });

      // add each police-office
      setState(() {
        _policeMarkers[name] = marker;
        // add police stations to set of safe points
        safePointsMarkers.addAll(_policeMarkers.values.toSet());
      });
    }

    // add all custom made points (DangerPoints and RecommendationPoints)
    for (final point in points) {
      var mainType = getMainType(point["main_type"]);
      var subType = getSubType(point["sub_type"], point["main_type"]);
      var latLng =
      LatLng(double.parse(point["lat"]), double.parse(point["long"]));
      var latitude = latLng.latitude;
      var longitude = latLng.longitude;
      var title = point["title"];
      var description = point["comment"];
      var markerId = "$mainType-$subType-$latitude-$longitude-$title";
      var customMarkerIcon = BitmapDescriptor.defaultMarker;
      await getBytesFromAsset(subType.markerSrc, 150).then((onValue) {
        customMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
      });

      final marker = Marker(
          markerId: MarkerId(markerId),
          position: latLng,
          icon: customMarkerIcon,
          onTap: () =>
          {
            customInfoWindowController.addInfoWindow!(
                PointInfoWindow(
                    mainType: mainType,
                    subType: subType,
                    title: title,
                    description: description,
                    votes: 0),
                latLng)
          });

      // add teach point to the set
      setState(() {
        switch (mainType) {
          case MainType.dangerPoint:
            _dangerPointsMarkers.add(marker);
            break;
          case MainType.recommendationPoint:
            _recommendationPointsMarkers.add(marker);
            break;
          case MainType.safePoint:
            _safePointsMarkers.add(marker);
        }
      });
    }

    //add prefetched points from the DB to the map
    setState(() {
      dangerPointsMarkers.addAll(_dangerPointsMarkers);
      safePointsMarkers.addAll(_safePointsMarkers);
      recommendationPointsMarkers.addAll(_recommendationPointsMarkers);
    });
  }

  Future<void> showInformationDialog(LatLng latLng,
      BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return DialogWindow(
                latLng: latLng,
                customInfoWindowController: customInfoWindowController,
                updateMarkers: (marker) => addCustomMarker(marker));
          });
        });
  }

  // callback function for adding a custom marker (DangerPoint or InformationPoint)
  // into set accordingly to its type
  void addCustomMarker(Marker marker) {
    // add marker according to its category (DangerPoint or InformationPoint)
    setState(() {
      if (marker.markerId.value.startsWith("MainType.dangerPoint")) {
        dangerPointsMarkers.add(marker);
      } else if (marker.markerId.value
          .startsWith("MainType.recommendationPoint")) {
        recommendationPointsMarkers.add(marker);
      }
      updatePointsVisibility();
    });
  }

  // set visibility of different types of points on the map, based on current settings
  updatePointsVisibility() {
    if (_selectedFilters[0]) {
      setState(() {
        // show danger points
        currentlyActiveMarkers =
            currentlyActiveMarkers.union(dangerPointsMarkers);
      });
    } else {
      setState(() {
        // hide danger points
        currentlyActiveMarkers =
            currentlyActiveMarkers.difference(dangerPointsMarkers);
      });
    }
    if (_selectedFilters[1]) {
      setState(() {
        // show recommendation points
        currentlyActiveMarkers =
            currentlyActiveMarkers.union(recommendationPointsMarkers);
      });
    } else {
      setState(() {
        // hide recommendation points
        currentlyActiveMarkers =
            currentlyActiveMarkers.difference(recommendationPointsMarkers);
      });
    }
    if (_selectedFilters[2]) {
      setState(() {
        // show safe points
        currentlyActiveMarkers =
            currentlyActiveMarkers.union(safePointsMarkers);
      });
    } else {
      setState(() {
        // hide safe points
        currentlyActiveMarkers =
            currentlyActiveMarkers.difference(safePointsMarkers);
      });
    }
  }

  // TODO: implement SOS-functionality
  void SOSPressed() {
    print('Pressed SOS');
  }

  // TODO: implement share location functionality
  void shareLocation() {
    print('Pressed Share Location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeStreets'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Google Map widget
            _buildGoogleMap(),

            // Custom Info Window
            CustomInfoWindow(
              controller: customInfoWindowController,
              width: 300,
              height: 300,
              offset: 10,
            ),

            // Toggle Buttons
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 10.0),
              child: _buildToggleButtons(),
            ),

            // Speed Dial
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 15),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: _buildSpeedDial(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      // Callback when the map is created
      onMapCreated: _onMapCreated,

      // Callback when long-pressing on the map
      onLongPress: (LatLng latLng) async {
        try {
          await showInformationDialog(latLng, context);
        } catch (e) {
          // Handle the exception
          print('Error: $e');
        }
      },

      // Callback when tapping on the map
      onTap: (position) {
        customInfoWindowController.hideInfoWindow!();
      },

      // Callback when the camera is moved
      onCameraMove: (position) {
        customInfoWindowController.onCameraMove!();
      },

      // Map settings
      mapType: MapType.normal,
      initialCameraPosition: _kInitialPosition,
      markers: currentlyActiveMarkers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      trafficEnabled: false,
      mapToolbarEnabled: true,
      buildingsEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Toggle Buttons for filters
          ToggleButtons(
            direction: Axis.vertical,
            onPressed: (int index) {
              // All buttons are selectable.
              setState(() {
                _selectedFilters[index] = !_selectedFilters[index];
                updatePointsVisibility();
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.blue[700],
            selectedColor: Colors.white,
            fillColor: Colors.blue[200],
            color: Colors.blue[400],
            constraints: const BoxConstraints(
              minHeight: 50.0,
              minWidth: 50.0,
            ),
            isSelected: _selectedFilters,
            children: filters,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_arrow,
      animatedIconTheme: const IconThemeData(size: 25.0),
      backgroundColor: Colors.blue[600],
      visible: true,
      direction: SpeedDialDirection.up,
      curve: Curves.fastOutSlowIn,
      children: [
        // SOS Button
        SpeedDialChild(
          child: const Icon(Icons.sos, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: SOSPressed,
          label: 'SOS',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),

        // Share Location Button
        SpeedDialChild(
          child: const Icon(Icons.share_location, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: shareLocation,
          label: 'Share Location',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }

}
