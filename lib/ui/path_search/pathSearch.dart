import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding_platform_interface/src/models/location.dart'
    as GeocodingLocation;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/services/path_service.dart';
import 'package:safe_streets/ui/path_search/routes_models.dart';

import '../../shared/app_state.dart';
import '../../shared/global_functions.dart';

/// Widget and Functionality for the calculating and showing safe path
/// between two points on the map
class PathSearch extends StatefulWidget {
  final Function(Set<Marker> markers, Set<Polyline> polylines)
      onPathDataReceived;
  final Function() onDestinationPickerClicked;

  const PathSearch({
    super.key,
    required this.onPathDataReceived,
    required this.onDestinationPickerClicked,
  });

  @override
  State<StatefulWidget> createState() => _PathSearch();
}

class _PathSearch extends State<PathSearch> {
  final pathService = PathService();
  late final places;

  GoogleMapController? googleMapController;
  late AppState appState;

  // for custom start and destination icons
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  late Position _currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> _polylines = {};
  SafestRouteResponse response = SafestRouteResponse(
      totalCrimeLikelihood: 0.0,
      totalLength: 0.0,
      edgesList: []
  );
  List<LatLng> polylineCoordinates = [];

  bool isPathSearchShown = false;

  void _togglePathSearch() {
    setState(() {
      isPathSearchShown = !isPathSearchShown;
    });
  }

  // pass the markers and polylines to the callback function
  void _updatePathData() {
    widget.onPathDataReceived(markers, _polylines);
  }

  void _getCurrentLocation() async {
    try {
      Position position = await getCurrentLocation(googleMapController);
      setState(() {
        _currentPosition = position;
      });
      //await _getAddress();
    } catch (e) {
      print(e);
    }
  }

  // Method for retrieving the address
  Future<void> _getAddress() async {
    try {
      List<Placemark> p = await getAddresses(_currentPosition);
      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  void setSourceAndDestinationIcons() async {
    // getBytesFromAsset("lib/assets/markers/path_points/start_marker.png", 200)
    //     .then((onValue) {
    //   sourceIcon = BitmapDescriptor.fromBytes(onValue!);
    // });
    // getBytesFromAsset("lib/assets/markers/path_points/finish_marker.png", 200)
    //     .then((onValue) {
    //   destinationIcon = BitmapDescriptor.fromBytes(onValue!);
    // });
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance(
      GoogleMapController? googleMapController) async {
    try {
      // // Retrieving placemarks from addresses
      // List<GeocodingLocation.Location> startPlacemark =
      //     await locationFromAddress(_startAddress);
      // List<GeocodingLocation.Location> destinationPlacemark =
      //     await locationFromAddress(_destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      // double startLatitude = _startAddress == _currentAddress
      //     ? _currentPosition.latitude
      //     : startPlacemark[0].latitude;
      //
      // double startLongitude = _startAddress == _currentAddress
      //     ? _currentPosition.longitude
      //     : startPlacemark[0].longitude;
      //
      // double destinationLatitude = destinationPlacemark[0].latitude;
      // double destinationLongitude = destinationPlacemark[0].longitude;

      double startLatitude = 19.420343046001982;
      double startLongitude = -99.13602615649843;

      double destinationLatitude = 19.420343046009982;
      double destinationLongitude = -99.19247234027884;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        icon: sourceIcon,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        icon: destinationIcon,
      );

      // Adding the markers to the list
      setState(() {
        markers.add(startMarker);
        markers.add(destinationMarker);
      });

      // add to the main-map via callback function
      _updatePathData();

      // print(
      //   'START COORDINATES: ($startLatitude, $startLongitude)',
      // );
      // print(
      //   'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      // );

      List<double> cameraCoordinates = pathService.getCameraCoordinates(
          startLatitude,
          startLongitude,
          destinationLatitude,
          destinationLongitude);

      double southWestLatitude = cameraCoordinates[0];
      double southWestLongitude = cameraCoordinates[1];

      double northEastLatitude = cameraCoordinates[2];
      double northEastLongitude = cameraCoordinates[3];

      // Accommodate the two locations within the
      // camera view of the map
      googleMapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      await setPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      // add to the main-map via callback function
      _updatePathData();

      // Calculating the total distance by adding the distance
      // between small segments
      //totalDistance = pathService.calculateDistance(polylineCoordinates);
      totalDistance = response.totalLength; // length is already coming from endpoint

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        // print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // creates the set of polylines from the start point to the destination point
  setPolylines(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) async {
    // standard google maps path
    // polylineCoordinates = await pathService.getPolylineCoordinates(
    //     startLatitude,
    //     startLongitude,
    //     destinationLatitude,
    //     destinationLongitude);

    // safest path (ML)
    response = (await pathService.getSafestPath(
        startLatitude,
        startLongitude,
        destinationLatitude,
        destinationLongitude))!;

    // extract polylines to show them on map
    for (final edge in response.edgesList) {
      for (final coordinates in edge.geometry) {
        polylineCoordinates.add(LatLng(coordinates[0], coordinates[1]));
      }
    }

    print(response.totalCrimeLikelihood);
    print(response.totalLength);

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: const PolylineId("poly"),
          color: const Color.fromARGB(200, 0, 170, 136),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);

      _updatePathData();
    });

    // setState(() {
    //   // create polylines one-by-one with own id and color
    //   for(final edge in response.edgesList) {
    //     // parse coordinates into 1 pair of LatLng
    //     List<LatLng> polyCoordinates = [];
    //     // start (x and y)
    //     polyCoordinates.add(LatLng(edge.geometry[0][0], edge.geometry[0][1]));
    //     // end (x and y)
    //     polyCoordinates.add(LatLng(edge.geometry[1][0], edge.geometry[1][1]));
    //
    //     // create a single polyline
    //     Polyline polyline = Polyline(
    //         polylineId: PolylineId(edge.osmid),
    //         color: _getColorByCrimeRate(edge.predCrimeLikelihood),
    //         points: polyCoordinates,
    //         jointType: JointType.bevel,
    //         width: 10,
    //         zIndex: 0,
    //         onTap: () {
    //           print('predCrimeLikelihood: ${edge.predCrimeLikelihood}');
    //           _showCrimeLikelihoodTooltip(edge.predCrimeLikelihood.toString());
    //         },
    //     );
    //
    //     // add polyline to the map
    //     _polylines.add(polyline);
    //   }
    //
    //   _updatePathData();
    // });
  }

  // returns a color based on given predictive crime likelihood
  // @param predCrimeLikelihood is a double number from 0.0 to 10.0 only
  Color _getColorByCrimeRate(double predCrimeLikelihood) {
    if (predCrimeLikelihood <= 1.0) {
      return Colors.red;
    } else if (predCrimeLikelihood <= 2.0) {
      return Colors.deepOrange;
    } else if (predCrimeLikelihood <= 3.0) {
      return Colors.orange;
    } else if (predCrimeLikelihood <= 4.0) {
      return Colors.amber;
    } else if (predCrimeLikelihood <= 5.0) {
      return Colors.yellow;
    } else if (predCrimeLikelihood <= 6.0) {
      return Colors.lime;
    } else if (predCrimeLikelihood <= 7.0) {
      return Colors.lightGreen;
    } else if (predCrimeLikelihood <= 8.0) {
      return Colors.green;
    } else if (predCrimeLikelihood <= 9.0) {
      return Colors.lightBlue;
    } else {
      return Colors.blue;       // <= 10.0
    }
  }

  void _showCrimeLikelihoodTooltip(String crimeLikelihood) {
    const duration = Duration(seconds: 2);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0,
        left: 100.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Crime Likelihood: $crimeLikelihood',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context)!.insert(overlayEntry);
    Timer(duration, () {
      overlayEntry.remove();
    });
  }

  // cleans the path-markers, distance and polylines
  void _cleanPath() {
    setState(() {
      _currentAddress = "";
      _destinationAddress = "";
      startAddressController.text = "";
      destinationAddressController.text = "";
      startAddressController.clear();
      destinationAddressController.clear();
      appState.destinationAddress = "";
      _polylines.clear();
      markers.clear();
      _placeDistance = null;
      _updatePathData();
    });
  }

  // Method for exchanging start and destination addresses
  void _exchangeAddresses() {
    setState(() {
      // Swap the values of start and destination addresses
      String tempAddress = _startAddress;
      _startAddress = _destinationAddress;
      _destinationAddress = tempAddress;
      appState.destinationAddress = tempAddress;

      // Swap the values of start and destination text fields
      startAddressController.text = _startAddress;
      destinationAddressController.text = _destinationAddress;
    });
  }

  void _destinationAddressListener() {
    // Update the destinationAddressController whenever appState.destinationAddress changes
    destinationAddressController.text = appState.destinationAddress;
    _destinationAddress = appState.destinationAddress;
  }

  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
    googleMapController = appState.controller;
    _getCurrentLocation();
    setSourceAndDestinationIcons();

    // Set the initial values of the controllers
    startAddressController.text = _startAddress;
    destinationAddressController.text = appState.destinationAddress;

    // Add a listener to appState.destinationAddress
    appState.addListener(_destinationAddressListener);

    // for addresses-autocompletion
    places = GoogleMapsPlaces(apiKey: pathService.apiKey);
  }

  @override
  void dispose() {
    startAddressController.dispose();
    destinationAddressController.dispose();
    startAddressFocusNode.dispose();
    destinationAddressFocusNode.dispose();
    places.dispose();
    _cleanPath();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isPathSearchShown ? showPathSearchContainer() : showPlaceholder()),
    );
  }

  // show toggle-button for pathSearch container
  Widget showPlaceholder() {
    return ElevatedButton(
          onPressed: _togglePathSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            elevation: 10,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Find place',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
              Spacer(),
              Icon(
                Icons.search,
                color: Colors.black,
              ),
            ],
      ),
    );
  }

  // show the full info-container with start/destination and actions
  Widget showPathSearchContainer() {
    //var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final googleMapController = appState.controller;

    // Show the place input fields & button for showing the route
    // consumer for picking destination-address is needed
    return Consumer<AppState>(builder: (context, appState, _) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _textField(
                  label: 'Start',
                  hint: 'Choose starting point',
                  prefixIcon: const Icon(Icons.start),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () {
                      _getAddress();
                      startAddressController.text = _currentAddress;
                      _startAddress = _currentAddress;
                    },
                  ),
                  controller: startAddressController,
                  focusNode: startAddressFocusNode,
                  width: width,
                  locationCallback: (String value) {
                    setState(() {
                      _startAddress = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _textField(
                  label: 'Destination',
                  hint: 'Choose destination',
                  prefixIcon: const Icon(Icons.flag),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.location_pin),
                    onPressed: () {
                      // show destination-picker with address-field
                      widget.onDestinationPickerClicked();
                      // update the field when clicking on accept-button
                      // on destination-picker field
                      destinationAddressController.text =
                          appState.destinationAddress;
                      _destinationAddress = appState.destinationAddress;
                    },
                  ),
                  controller: destinationAddressController,
                  focusNode: destinationAddressFocusNode,
                  width: width,
                  locationCallback: (String value) {
                    setState(() {
                      _destinationAddress = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _placeDistance == null ? false : true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'DISTANCE: $_placeDistance km',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'SAFETY: ${response.totalCrimeLikelihood}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _exchangeAddresses,
                      child: const Icon(
                        Icons.swap_vert,
                        color: Colors.tealAccent,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: (_startAddress != '' &&
                              _destinationAddress != '')
                          ? () async {
                              startAddressFocusNode.unfocus();
                              destinationAddressFocusNode.unfocus();
                              setState(() {
                                if (markers.isNotEmpty) {
                                  markers.clear();
                                }
                                if (_polylines.isNotEmpty) {
                                  _polylines.clear();
                                }
                                if (polylineCoordinates.isNotEmpty) {
                                  polylineCoordinates.clear();
                                }
                                _placeDistance = null;
                                // add to the main-map via callback function
                                _updatePathData();
                              });

                              _calculateDistance(googleMapController)
                                  .then((isCalculated) {
                                if (isCalculated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Distance Calculated Successfully'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error Calculating Distance'),
                                    ),
                                  );
                                }
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Show Route'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _togglePathSearch();
                        _cleanPath();
                      },
                      child: const Icon(
                        Icons.cleaning_services,
                        color: Colors.tealAccent,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ],
        ),
      );
    });
  }

  // textual fields for manually writing the start/destination addresses.
  // has a address-suggestion feature
  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    required Widget suffixIcon,
    required Function(String) locationCallback,
  }) {
    return SizedBox(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.teal.shade300,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }
}
