import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/main_pages/map/path_search/components/pathSearch.dart';
//import 'package:safe_streets/ui/spinners/loading_spinner.dart';

import '../../services/point_approaching.dart';
import '../../services/safe_points_service.dart';
import '../../shared/app_state.dart';
import '../../shared/global_functions.dart';
import '../../shared/points_types.dart';
import '../../ui/bottom_menu/bottom_navigation_bar.dart';
import '../../ui/fake_call/fake_call.dart';
import '../../ui/infowindow/point_infowindow.dart';
import '../../ui/dialog/dialog_window.dart';
import '../../ui/sos/sos_window.dart';
import 'current_place_information/current_place_info.dart';

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
  LatLng? _currentCameraPosition;

  String destinationLocation = "";
  bool isDestinationPickerVisible = false;
  bool _isInfoWindowVisible = false;

  late AppState appState;
  GoogleMapController? _googleMapController;
  late Position _currentPosition;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MapType _currentMapType = MapType.normal;

  // polylines and markers (start, finish) for SafePath-feature
  Set<Polyline> polylines = {};
  Set<Marker> pathMarkers = {};

  // all info-markers (danger, recommendation, safe, info-areas)
  Set<Marker> currentlyActiveMarkers = {};
  Set<Marker> dangerPointsMarkers = {};
  Set<Marker> safePointsMarkers = {};
  Set<Marker> recommendationPointsMarkers = {};
  final Map<String, Marker> _policeMarkers = {};
  final Set<Marker> _dangerPointsMarkers = {};
  final Set<Marker> _safePointsMarkers = {};
  final Set<Marker> _recommendationPointsMarkers = {};

  // for switching the visibility of all controllers, buttons
  bool _areControllersVisible = true;

  String customMapStyle = '';

  @override
  initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
    destinationLocation = appState.destinationAddress;
    // set GoogleMapController to the global one across the components
    _googleMapController = widget.googleMapController;
    _loadCustomMapStyle();
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

  void _loadCustomMapStyle() async {
    // Load the custom map style JSON file from assets
    final String style = await rootBundle.loadString('lib/assets/data/map_styling.json');

    setState(() {
      customMapStyle = style;
    });
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
  Future<void> _fetchPlaces() async {
    // clear all markers
    setState(() {
      _policeMarkers.clear();
      _dangerPointsMarkers.clear();
      _safePointsMarkers.clear();
      _recommendationPointsMarkers.clear();
    });

    // call functions for fetching separately SsafePoints (police stations)
    // and CustomPoints (Danger and Recommendation)
    _fetchPoliceStations();
    _fetchCustomPoints();

    //add prefetched points from the DB to the map
    setState(() {
      dangerPointsMarkers.addAll(_dangerPointsMarkers);
      safePointsMarkers.addAll(_safePointsMarkers);
      recommendationPointsMarkers.addAll(_recommendationPointsMarkers);
    });
  }

  /// set on map all Police Stations (SafePoints)
  Future<void> _fetchPoliceStations() async {
    // Fetch police stations and using the service
    var policeStations = await safePointsService.fetchPoliceStations();

    //iterate through the police stations and create a marker with InfoWindow for each
    for (final policeStation in policeStations) {
      var name = policeStation["name"];
      var marker = await safePointsService.getPoliceMarker(policeStation);

      // add each police-office
      setState(() {
        _policeMarkers[name] = marker;
      });
    }

    // add police stations to set of safe points
    setState(() {
      safePointsMarkers.addAll(_policeMarkers.values.toSet());
    });
  }

  /// set on map all Custom Points (DangerPoints and RecommendationPoints)
  Future<void> _fetchCustomPoints() async {
    // Fetch custom points using the service
    var customPoints = await safePointsService.fetchCustomPoints();

    // add all custom made points (DangerPoints and RecommendationPoints)
    for (final customPoint in customPoints) {
      var mainType = getMainType(customPoint["main_type"]);
      var marker = await safePointsService.getCustomMarker(customPoint, _onMarkerTap);

      // add each point to the set
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
  }

  void _onMarkerTap(PointInfoWindow infoWindow) {
    setState(() {
      // toggle the visibility of infoWindow, passing the fetched data
      appState.currentlySelectedPoint = infoWindow;
      _toggleInfoWindowVisibility();
    });
  }

  void _toggleInfoWindowVisibility() {
    setState(() {
      if(appState.currentlySelectedPoint.pointId.isNotEmpty) {
        _isInfoWindowVisible = !_isInfoWindowVisible;
      }
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
    // update shared appState
    final appState = Provider.of<AppState>(context, listen: false);
    appState.activeMarkers = currentlyActiveMarkers;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fakeCallPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const FakeCallWidget(callerName: 'Bob')),
    );
  }

  void sosPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SOSWidget()),
    );
  }

  // void shareLocation() {
  //   print('Pressed Share Location');
  // }

  void _onDestinationPickerClicked() {
    setState(() {
      isDestinationPickerVisible = true;
    });
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _showDetailedPointsMenu() {
    // TODO: navigate to screen with selection of points sub-types
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

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Route-builder enables searching for points and building a navigation path between them
                Visibility(
                  visible: _areControllersVisible,
                  child: PathSearch(
                    onPathDataReceived: onPathDataReceived,
                    onDestinationPickerClicked: _onDestinationPickerClicked,
                  ),
                ),

                // Toggle Buttons (point-types)
                Visibility(
                  visible: _areControllersVisible,
                  child: Positioned(
                    top: 50,
                    child: _buildToggleButtons(),
                  ),
                ),

                // service for showing the push-notifications when approaching to close to the point
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: _areControllersVisible,
                        child: const PointApproaching(),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Show current location button and zoom-buttons
            Visibility(
              visible: _areControllersVisible,
              child: Positioned(
                bottom: 30,
                left: 10,
                child: _buildCustomMapButtons(),
              ),
            ),

            // SOS-button
            Positioned(
              bottom: 30,
              right: 10,
              child: ClipRect(
                child: Material(
                  color: Colors.red,
                  child: InkWell(
                    splashColor: Colors.white,
                    onTap: sosPressed,
                    child: const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(Icons.sos, color: Colors.white, size: 40),
                    ),
                  ),
                ),
              ),
            ),

            CurrentPlaceInfo(
                place: "Freimann",
                safetyIndex: 2.1,
                overview:
                    "A lot of pickpocketing happens in this area. Make sure to keep eye on your belongings."),

            // // speed-dial for actions: fake-call, sos, location-sharing
            // Visibility(
            //   visible: _areControllersVisible,
            //   child: Positioned(
            //     bottom: 30,
            //     left: 10,
            //     child: _buildSpeedDial(),
            //   ),
            // ),

            // Custom Info Window
            Visibility(
              visible: _isInfoWindowVisible,
              child: appState.currentlySelectedPoint,
            ),

            // destination-picker for the PathSearch
            Visibility(
                visible: isDestinationPickerVisible,
                child: Center(
                  child: Image.asset(
                    "lib/assets/markers/path_points/finish_marker.png",
                    width: 80,
                  ),
                )),

            // widget to display destination-location name
            _buildDestinationSafePathPicker(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      // Map settings
      mapType: _currentMapType,
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
      indoorViewEnabled: false,
      // Callback when the map is created
      onMapCreated: (controller) {
        setState(() {
          controller.setMapStyle(customMapStyle);
          _googleMapController = controller;
        });
        // get the places with markers on the map
        _fetchPlaces();
      },
      onLongPress: (LatLng latLng) async {
        // Show the PointCreationWindow when there's a long press
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          showDragHandle: true,
          builder: (BuildContext context) {
            return PointCreationWindow(
              latLng: latLng,
              updateMarkers: (marker) => addCustomMarker(marker),
              onTapCallback: (infoWindow) => _onMarkerTap(infoWindow)
            );
          },
        );
      },
      onTap: (position) {
        _toggleInfoWindowVisibility();
        // // trigger the visibility of controllers
        // setState(() {
        //   _areControllersVisible = !_areControllersVisible;
        // });
      },
      // Callback when the camera is moved
      onCameraMove: (position) {
        setState(() {
          _currentCameraPosition = position.target;
        });
      },
      // when map drag stops - for destination-picker in pathSearch
      onCameraIdle: () async {
        if (_currentCameraPosition != null && isDestinationPickerVisible == true) {
          List<Placemark> destinationPlacemarks =
              await placemarkFromCoordinates(_currentCameraPosition!.latitude,
                  _currentCameraPosition!.longitude);
          setState(() {
            // get place name from lat and lang
            destinationLocation =
                "${destinationPlacemarks.first.administrativeArea}, ${destinationPlacemarks.first.street}";
          });
        }
      },
    );
  }

  // custom buttons for changing map-type, zooming-in, zooming-out
  // and zooming to the current geolocation
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
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.white70,
                    onTap: _toggleMapType,
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.layers),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipOval(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.white70,
                    child: const SizedBox(
                      width: 30,
                      height: 30,
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
              const SizedBox(height: 10),
              ClipOval(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.white70,
                    child: const SizedBox(
                      width: 30,
                      height: 30,
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
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.white70,
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

  // badge-buttons to filter through point-types: danger, recommendation, safe
  Widget _buildToggleButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _buildToggleBadge(
            text: 'Danger Points',
            icon: Icons.notification_important,
            toggledIcon: Icons.notification_important_outlined,
            toggled: _selectedFilters[0],
            onTap: () {
              setState(() {
                _selectedFilters[0] = !_selectedFilters[0];
              });
              updatePointsVisibility();
            },
          ),
          _buildToggleBadge(
            text: 'Recommendation Points',
            icon: Icons.question_mark,
            toggledIcon: Icons.question_mark_outlined,
            toggled: _selectedFilters[1],
            onTap: () {
              setState(() {
                _selectedFilters[1] = !_selectedFilters[1];
              });
              updatePointsVisibility();
            },
          ),
          _buildToggleBadge(
            text: 'Safe Points',
            icon: Icons.handshake,
            toggledIcon: Icons.handshake_outlined,
            toggled: _selectedFilters[2],
            onTap: () {
              setState(() {
                _selectedFilters[2] = !_selectedFilters[2];
              });
              updatePointsVisibility();
            },
          ),
          GestureDetector(
            onTap: _showDetailedPointsMenu,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.more_horiz, color: Colors.white, size: 15),
                        Text('More',
                            style: TextStyle(color: Colors.white, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // element of toggle-badge that changes the visual by toggling it
  Widget _buildToggleBadge({
    required String text,
    required IconData icon,
    required IconData toggledIcon,
    required bool toggled,
    required VoidCallback onTap,
  }) {
    Color badgeColor = Colors.white;
    if(toggled) {
      if(text == "Danger Points") {
        badgeColor = Colors.redAccent;
      } else if(text == "Recommendation Points") {
        badgeColor = Colors.yellowAccent;
      } else if(text == "Safe Points") {
        badgeColor = Colors.greenAccent;
      } else {
        badgeColor = Colors.tealAccent;
      }
    }
    IconData badgeIcon = toggled ? toggledIcon : icon;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                children: [
                  Icon(badgeIcon, color: Colors.black, size: 15),
                  Text(text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight:
                              toggled ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // initial filters (danger-points, safe-points and tourists-points)
  final List<bool> _selectedFilters = <bool>[false, false, false];

  // Widget _buildSpeedDial() {
  //   return SpeedDial(
  //     animatedIcon: AnimatedIcons.menu_arrow,
  //     animatedIconTheme: const IconThemeData(size: 25.0),
  //     backgroundColor: Colors.teal[600],
  //     visible: true,
  //     direction: SpeedDialDirection.up,
  //     curve: Curves.fastOutSlowIn,
  //     children: [
  //       // Fake-Call Button
  //       SpeedDialChild(
  //           child: const Icon(Icons.call, color: Colors.white),
  //           backgroundColor: Colors.teal,
  //           onTap: fakeCallPressed,
  //           label: 'Fake-Call',
  //           labelStyle: const TextStyle(
  //               fontWeight: FontWeight.w500, color: Colors.white),
  //           labelBackgroundColor: Colors.black),
  //       // SOS Button
  //       SpeedDialChild(
  //         child: const Icon(Icons.sos, color: Colors.white),
  //         backgroundColor: Colors.teal,
  //         onTap: sosPressed,
  //         label: 'SOS',
  //         labelStyle:
  //             const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
  //         labelBackgroundColor: Colors.black,
  //       ),
  //
  //       // // Share Location Button
  //       // SpeedDialChild(
  //       //   child: const Icon(Icons.share_location, color: Colors.white),
  //       //   backgroundColor: Colors.teal,
  //       //   onTap: shareLocation,
  //       //   label: 'Share Location',
  //       //   labelStyle:
  //       //       const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
  //       //   labelBackgroundColor: Colors.black,
  //       // ),
  //     ],
  //   );
  // }

  _buildDestinationSafePathPicker() {
    return Consumer<AppState>(builder: (context, appState, _) {
      return Visibility(
        visible: isDestinationPickerVisible,
        child: Positioned(
            bottom: 200,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      leading: Image.asset(
                        "lib/assets/markers/path_points/finish_marker.png",
                        width: 25,
                      ),
                      title: Text(
                        destinationLocation,
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.done, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  isDestinationPickerVisible = false;
                                  if (appState.destinationAddress != null) {
                                    appState.destinationAddress =
                                        destinationLocation;
                                  }
                                  destinationLocation = '';
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  isDestinationPickerVisible = false;
                                  destinationLocation = '';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      dense: true,
                    )),
              ),
            )),
      );
    });
  }
}
