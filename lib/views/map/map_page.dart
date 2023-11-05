// import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/router.dart';
// import 'package:safe_streets/services/safe_points_service.dart';
// import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/views/map/fake_call_page.dart';
import 'package:safe_streets/views/map/widgets/base_map.dart';
// import 'package:safe_streets/widgets/dialog_window.dart';
// import 'package:safe_streets/views/map/widgets/path_search.dart';
// import 'package:safe_streets/widgets/loading_spinner.dart';

/// Main Page with the FilterMarkers-Map, including 3 types of Points
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _googleMapController;

  void _setMapController(GoogleMapController controller) {
    // setState((){
    _googleMapController = controller;
    // }
  }

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  late Position _currentPosition;

  @override
  initState() {
    super.initState();
    // _getCurrentLocation();
  }

  // void _getCurrentLocation() async {
  //   try {
  //     Position position = await getCurrentLocation(_googleMapController);
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          BaseMap(setMapController: _setMapController),

          // Route-builder enables searching for points and building a navigation path between them
          // PathSearch(
          //   googleMapController: _googleMapController,
          // onPathDataReceived: onPathDataReceived,
          // ),

          // Show current location button and zoom-buttons
          Positioned(
            bottom: 250,
            right: 10,
            child: ClipOval(
              child: Material(
                color: Colors.red.shade100, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.add_alert),
                  ),
                  onTap: () {
                    print('TAPPED');
                    context.pushNamed(AppRoutes.route);
                  },
                ),
              ),
            ),
          ),

          // Show current location button and zoom-buttons
          Positioned(
            bottom: 30,
            right: 10,
            child: _buildCustomMapButtons(),
          ),

          //   // Toggle Buttons
          //   Positioned(
          //     top: 30,
          //     left: 10,
          //     child: _buildToggleButtons(),
          //   ),

          //   // Custom Info Window
          //   CustomInfoWindow(
          //     controller: customInfoWindowController,
          //     width: 300,
          //     height: 300,
          //     offset: 50,
          //   ),

          //   // Speed Dial
          //   Positioned(
          //     bottom: 30,
          //     left: 10,
          //     child: _buildSpeedDial(),
          //   ),
        ],
      ),
    ));
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
