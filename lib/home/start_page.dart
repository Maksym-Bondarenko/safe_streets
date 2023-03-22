import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

import '../ui/infowindow/danger_point_infowindow.dart';

import 'dart:ui' as ui;

import '../src/locations.dart' as locations;

import '../ui/infowindow/points_types.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  BitmapDescriptor dangerMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor safeMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor touristicMarkerIcon = BitmapDescriptor.defaultMarker;

  static final LatLng _kMapGarchingCenter = LatLng(48.249521, 11.653154);

  static final CameraPosition _kInitialPosition = CameraPosition(
      target: _kMapGarchingCenter, zoom: 17.0, tilt: 0, bearing: 0);

  final CustomInfoWindowController customInfoWindowController =
  CustomInfoWindowController();

  Completer<GoogleMapController> _googleMapController = Completer();

  Set<Marker> currentlyActiveMarkers = {};
  Set<Marker> dangerPointsMarkers = {};
  Set<Marker> safePointsMarkers = {};
  Set<Marker> touristicPointsMarkers = {};

  // add nearby police stations to the safe points
  // TODO

  // initial filters (show Data-Driven Styling map boundaries, danger-points, safe-points and tourists-points)
  final List<bool> _selectedFilters = <bool>[true, true, false];

  // visual of ToggleButtons
  static const List<Widget> filters = <Widget>[
    Icon(Icons.notification_important),
    Icon(Icons.health_and_safety),
    Icon(Icons.info),
  ];

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
    if (_selectedFilters[2]) {
      setState(() {
        // show touristic points
        currentlyActiveMarkers =
            currentlyActiveMarkers.union(touristicPointsMarkers);
      });
    } else {
      setState(() {
        // hide touristic points
        currentlyActiveMarkers =
            currentlyActiveMarkers.difference(touristicPointsMarkers);
      });
    }
  }

  @override
  initState() {
    // change map-icon from default to custom
    // getBytesFromAsset('lib/assets/marker/danger_point_marker.png', 150)
    //     .then((onValue) {
    //   dangerMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    // });

    updatePointsVisibility();
    super.initState();
  }

  final Map<String, Marker> _policeMarkers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // set up controllers
    _googleMapController.complete(controller);
    customInfoWindowController.googleMapController = controller;

    getBytesFromAsset('lib/assets/marker/safe_point_marker.png', 150)
        .then((onValue) {
      safeMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    // fetch safePoints (police stations)
    final offices = await locations.getGoogleOffices();
    setState(() {
      _policeMarkers.clear();
      for (final office in offices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.id),
          position: LatLng(office.lat, office.lng),
          icon: safeMarkerIcon,
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _policeMarkers[office.name] = marker;
      }

      // add police stations to set of safe points
      safePointsMarkers.addAll(_policeMarkers.values.toSet());
    });
  }

  // Future<void> createTouristicPoints() async {
  //   await getBytesFromAsset('lib/assets/marker/touristic_point_marker.png', 150).then((onValue) {
  //     touristicMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
  //   });
  //
  //   double lat = 48.249521;
  //   double lng = 11.653154;
  //
  //   for (int i = 0; i < 10; i++) {
  //     touristicPointsMarkers.add(Marker(
  //       markerId: MarkerId("touristicPoint-$i"),
  //       position: LatLng(lat * (i * 0.1), lng * (i * 0.1)),
  //       icon: touristicMarkerIcon,
  //       onTap: () {
  //         customInfoWindowController.addInfoWindow!(
  //             DangerPointInfoWindow(
  //                 pointType: TouristicPoints.traditional,
  //                 title: "Title",
  //                 description: "description ...",
  //                 votes: 4),
  //             LatLng(lat * (i * 0.1), lng * (i * 0.1)));
  //       },
  //     ));
  //   }
  // }

  // change default google-marker-icon to custom one
  static Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  Future<void> createPoint(LatLng latLng, DangerPoints pointType,
      String title, String description) async {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "$pointType-$latitude-$longitude-$title";
    var votes = 0;

    // change a marker according to type of dangerous-point
    await getBytesFromAsset(pointType.markerSrc, 150).then((onValue) {
      dangerMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    setState(() {
      dangerPointsMarkers.add(Marker(
        markerId: MarkerId(markerId),
        position: LatLng(latitude, longitude),
        icon: dangerMarkerIcon,
        onTap: () {
          customInfoWindowController.addInfoWindow!(
              DangerPointInfoWindow(
                  pointType: pointType,
                  title: title,
                  description: description,
                  votes: votes),
              LatLng(latitude, longitude));
        },
      ));
      updatePointsVisibility();
    });
  }

  Future<void> showInformationDialog(LatLng latLng,
      BuildContext context) async {
    // Dialog Form
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleController =
    TextEditingController(text: "");
    final TextEditingController descriptionController =
    TextEditingController(text: "");
    var pointType = DangerPoints.lightPoint;
    List<DangerPoints> allPointTypes = DangerPoints.values;

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create a Point'),
              content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<DangerPoints>(
                        value: pointType,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 15,
                        underline: Container(
                          height: 2,
                        ),
                        items: allPointTypes
                            .map<DropdownMenuItem<DangerPoints>>(
                                (DangerPoints value) {
                              return DropdownMenuItem<DangerPoints>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                        onChanged: (DangerPoints? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            pointType = value!;
                          });
                        },
                      ),
                      TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please, enter the title";
                          }
                          return null;
                        },
                        decoration:
                        const InputDecoration(hintText: "Enter the Title"),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 8,
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: const Text('Submit'),
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Adding a ${pointType.name}...')),
                      );
                      // create a DangerPoint with given data
                      createPoint(
                          latLng,
                          pointType,
                          titleController.value.text,
                          descriptionController.value.text);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Something gone wrong...')),
                      );
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topCenter,
          child: Image.asset('lib/assets/images/logo_small.png', color: Colors.red, height: 150),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onLongPress: (LatLng latLng) async =>
              await showInformationDialog(latLng, context),
            onTap: (position) {
              customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              customInfoWindowController.onCameraMove!();
            },
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
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 200,
            width: 300,
            offset: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 15),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SpeedDial(
                animatedIcon: AnimatedIcons.menu_arrow,
                animatedIconTheme: const IconThemeData(size: 25.0),
                backgroundColor: Colors.red[600],
                visible: true,
                direction: SpeedDialDirection.up,
                curve: Curves.fastOutSlowIn,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.sos, color: Colors.white),
                    backgroundColor: Colors.red,
                    onTap: () => print('Pressed SOS'),
                    label: 'SOS',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                    labelBackgroundColor: Colors.black,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.share_location,
                        color: Colors.white),
                    backgroundColor: Colors.green,
                    onTap: () => print('Pressed Share Location'),
                    label: 'Share Location',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                    labelBackgroundColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
