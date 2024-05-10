import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/services/path_service.dart';

// Widget and Functionality for the calculating and showing safe path
// between two points on the map
class PathSearch extends StatefulWidget {
  final GoogleMapController? googleMapController;
  final Function(Set<Marker> markers, Set<Polyline> polylines)? onPathDataReceived;

  const PathSearch({
    super.key,
    required this.googleMapController,
    this.onPathDataReceived,
  });

  @override
  State<StatefulWidget> createState() => _PathSearch();
}

class _PathSearch extends State<PathSearch> {
  final pathService = PathService();

  GoogleMapController? googleMapController;

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
  List<LatLng> polylineCoordinates = [];

  // pass the markers and polylines to the callback function
  void _updatePathData() {
    // widget.onPathDataReceived(markers, _polylines);
  }

  void _getCurrentLocation() async {
    try {
      // Position position = await getCurrentLocation(googleMapController);
      // setState(() {
      //   _currentPosition = position;
      // });
      // await _getAddress();
    } catch (e) {
      print(e);
    }
  }

  // Method for retrieving the address
  Future<void> _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), "assets/markers/path/start_marker.png");
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), "assets/markers/path/finish_marker.png");
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance(GoogleMapController? googleMapController) async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark = await locationFromAddress(_destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      double startLatitude = _startAddress == _currentAddress ? _currentPosition.latitude : startPlacemark[0].latitude;

      double startLongitude =
          _startAddress == _currentAddress ? _currentPosition.longitude : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString = '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        // TODO: uncomment
        // icon: sourceIcon,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        // TODO: uncomment
        // icon: destinationIcon,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      // add to the main-map via callback function
      _updatePathData();

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude) ? startLatitude : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude) ? startLongitude : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude) ? destinationLatitude : startLatitude;
      double maxx = (startLongitude <= destinationLongitude) ? destinationLongitude : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

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

      await setPolylines(startLatitude, startLongitude, destinationLatitude, destinationLongitude);

      double totalDistance = 0.0;

      // add to the main-map via callback function
      _updatePathData();

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += pathService.coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // creates the set of polylines from the start point to the destination point
  setPolylines(
      double startLatitude, double startLongitude, double destinationLatitude, double destinationLongitude) async {
    // TODO: move to service
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(dotenv.env['GOOGLE_MAPS_API_KEY']!,
        PointLatLng(startLatitude, startLongitude), PointLatLng(destinationLatitude, destinationLongitude),
        travelMode: TravelMode.walking);
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: const PolylineId("poly"),
          color: const Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);

      _updatePathData();
    });
  }

  @override
  void initState() {
    super.initState();
    googleMapController = widget.googleMapController;
    _getCurrentLocation();
    // TODO: uncomment
    //setSourceAndDestinationIcons();
  }

  @override
  void dispose() {
    startAddressController.dispose();
    destinationAddressController.dispose();
    startAddressFocusNode.dispose();
    destinationAddressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final googleMapController = widget.googleMapController;

    // Show the place input fields & button for showing the route
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        child: DraggableScrollableSheet(
          initialChildSize: 0.08,
          minChildSize: 0.08, // Minimum size when fully collapsed
          maxChildSize: 0.35, // Maximum size when fully expanded
          builder: (BuildContext context, ScrollController scrollController) {
            return Opacity(
              opacity: 0.8,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // horizontal line to show that widget is draggable
                        Container(
                          height: 4.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Get Safe Route',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(height: 10),
                        _textField(
                          label: 'Start',
                          hint: 'Choose starting point',
                          prefixIcon: const Icon(Icons.start),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () {
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
                          child: Text(
                            'DISTANCE: $_placeDistance km',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: (_startAddress.isNotEmpty && _destinationAddress.isNotEmpty)
                              ? () async {
                                  startAddressFocusNode.unfocus();
                                  destinationAddressFocusNode.unfocus();
                                  setState(() {
                                    if (markers.isNotEmpty) markers.clear();
                                    if (_polylines.isNotEmpty) _polylines.clear();
                                    if (polylineCoordinates.isNotEmpty) {
                                      polylineCoordinates.clear();
                                    }
                                    _placeDistance = null;
                                    // add to the main-map via callback function
                                    _updatePathData();
                                  });

                                  _calculateDistance(googleMapController).then((isCalculated) {
                                    if (isCalculated) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Distance Calculated Successfully'),
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
                            backgroundColor: Colors.blue,
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
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
              color: Colors.blue.shade300,
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
