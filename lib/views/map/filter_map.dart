import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/services/safe_points_service.dart';
import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/views/map/fake_call_page.dart';
import 'package:safe_streets/views/map/widgets/path_search.dart';
import 'package:safe_streets/widgets/dialog_window.dart';
// import 'package:safe_streets/widgets/spinners/loading_spinner.dart';

/// Main Page with the FilterMarkers-Map, including 3 types of Points
class FilterMap extends StatefulWidget {
  final GoogleMapController? googleMapController;

  const FilterMap({super.key, required this.googleMapController});

  @override
  State<StatefulWidget> createState() => _FilterMap();
}

class _FilterMap extends State<FilterMap> {
  // service for retrieving (fetch, post, http) the safe points by map-initialisation
  final safePointsService = SafePointsService();

  static const LatLng _kMapMunichCenter = LatLng(48.1351, 11.582);

  static const CameraPosition _kInitialPosition = CameraPosition(
      target: _kMapMunichCenter, zoom: 10.0, tilt: 0, bearing: 0);

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController? _googleMapController;

  late Position _currentPosition;

  Set<Polyline> polylines = {};
  Set<Marker> pathMarkers = {};

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
    // set GoogleMapController to the global one across the components
    _googleMapController = widget.googleMapController;
    _getCurrentLocation();
    updatePointsVisibility();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await getCurrentLocation(_googleMapController);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  // callback-function from the PathSearch to show the start/destination
  // markers and the path as polylines
  void onPathDataReceived(
      Set<Marker> receivedMarkers, Set<Polyline> receivedPolylines) {
    setState(() {
      pathMarkers = receivedMarkers;
      polylines = receivedPolylines;
    });
  }

  /// fetch data from DB or google-api with corresponding sub-type and show them on the map
  Future<void> fetchPlaces() async {
    // clear all markers
    setState(() {
      _policeMarkers.clear();
      _dangerPointsMarkers.clear();
      _safePointsMarkers.clear();
      _recommendationPointsMarkers.clear();
    });

    // call functions for fetching separately SsafePoints (police stations)
    // and CustomPoints (Danger and Recommendation)
    fetchPoliceStations();
    fetchCustomPoints();

    //add prefetched points from the DB to the map
    setState(() {
      dangerPointsMarkers.addAll(_dangerPointsMarkers);
      safePointsMarkers.addAll(_safePointsMarkers);
      recommendationPointsMarkers.addAll(_recommendationPointsMarkers);
    });
  }

  /// set on map all Police Stations (SafePoints)
  Future<void> fetchPoliceStations() async {
    // Fetch police stations and using the service
    // TODO: uncomment
    //var policeStations = await safePointsService.fetchPoliceStations();

    // iterate through the police stations and create a marker with InfoWindow for each
    // for (final policeStation in policeStations) {
    //   var name = policeStation["name"];
    //   var marker = await safePointsService.getPoliceMarker(
    //       policeStation, customInfoWindowController);
    //
    //   // add each police-office
    //   setState(() {
    //     _policeMarkers[name] = marker;
    //   });
    // }

    // add police stations to set of safe points
    setState(() {
      safePointsMarkers.addAll(_policeMarkers.values.toSet());
    });
  }

  /// set on map all Custom Points (DangerPoints and RecommendationPoints)
  Future<void> fetchCustomPoints() async {
    // Fetch custom points using the service
    // TODO: uncomment
    //var customPoints = await safePointsService.fetchCustomPoints();

    // add all custom made points (DangerPoints and RecommendationPoints)
    // for (final customPoint in customPoints) {
    //   var mainType = getMainType(customPoint["main_type"]);
    //   var marker = await safePointsService.getCustomMarker(
    //       customPoint, customInfoWindowController);
    //
    //   // add each point to the set
    //   setState(() {
    //     switch (mainType) {
    //       case MainType.dangerPoint:
    //         _dangerPointsMarkers.add(marker);
    //         break;
    //       case MainType.recommendationPoint:
    //         _recommendationPointsMarkers.add(marker);
    //         break;
    //       case MainType.safePoint:
    //         _safePointsMarkers.add(marker);
    //     }
    //   });
    // }
  }

  Future<void> showInformationDialog(
      LatLng latLng, BuildContext context) async {
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

  @override
  void dispose() {
    customInfoWindowController.dispose();
    super.dispose();
  }

  void fakeCallPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const FakeCallPage(callerName: 'Bob')),
    );
  }

  // TODO: implement SOS-functionality
  void sosPressed() {
    print('Pressed SOS');
  }

  // TODO: implement share location functionality
  void shareLocation() {
    print('Pressed Share Location');
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('SafeStreets'),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Google Map widget
              _buildGoogleMap(),

              // Route-builder enables searching for points and building a navigation path between them
              PathSearch(
                googleMapController: _googleMapController,
                onPathDataReceived: onPathDataReceived,
              ),

              // Show current location button and zoom-buttons
              Positioned(
                bottom: 30,
                right: 10,
                child: _buildCustomMapButtons(),
              ),

              // Toggle Buttons
              Positioned(
                top: 30,
                left: 10,
                child: _buildToggleButtons(),
              ),

              // Custom Info Window
              CustomInfoWindow(
                controller: customInfoWindowController,
                width: 300,
                height: 300,
                offset: 50,
              ),

              // Speed Dial
              Positioned(
                bottom: 30,
                left: 10,
                child: _buildSpeedDial(),
              ),
            ],
          ),
        ));
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      // Map settings
      mapType: MapType.normal,
      initialCameraPosition: _kInitialPosition,
      markers: Set<Marker>.from(currentlyActiveMarkers.union(pathMarkers)),
      polylines: Set<Polyline>.of(polylines),
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
      // Callback when the map is created
      onMapCreated: (controller) {
        setState(() {
          _googleMapController = controller;
          customInfoWindowController.googleMapController = _googleMapController;
        });
        // get the places with markers on the map
        fetchPlaces();
      },
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
    );
  }

  // custom buttons for zooming-in, zooming-out and zooming to the
  // current geolocation
  Widget _buildCustomMapButtons() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Material(
                  color: Colors.blue.shade100, // button color
                  child: InkWell(
                    splashColor: Colors.blue, // inkwell color
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.add),
                    ),
                    onTap: () {
                      _googleMapController?.animateCamera(
                        CameraUpdate.zoomIn(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipOval(
                child: Material(
                  color: Colors.blue.shade100, // button color
                  child: InkWell(
                    splashColor: Colors.blue, // inkwell color
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.remove),
                    ),
                    onTap: () {
                      _googleMapController?.animateCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipOval(
                child: Material(
                  color: Colors.blueAccent.shade100,
                  child: InkWell(
                    splashColor: Colors.blueAccent,
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.my_location),
                    ),
                    onTap: () {
                      _googleMapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(
                              _currentPosition.latitude,
                              _currentPosition.longitude,
                            ),
                            zoom: 18.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              minHeight: 60.0,
              minWidth: 60.0,
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
        // Fake-Call Button
        SpeedDialChild(
            child: const Icon(Icons.call, color: Colors.white),
            backgroundColor: Colors.blue,
            onTap: fakeCallPressed,
            label: 'Fake-Call',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black),
        // SOS Button
        SpeedDialChild(
          child: const Icon(Icons.sos, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: sosPressed,
          label: 'SOS',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),

        // Share Location Button
        SpeedDialChild(
          child: const Icon(Icons.share_location, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: shareLocation,
          label: 'Share Location',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }
}
