import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;

import '../infowindow/danger_point_infowindow.dart';
import '../infowindow/points_types.dart';

class PointsCreator {
  Set<Marker> currentlyActiveMarkers = {};
  Set<Marker> dangerPointsMarkers = {};
  Set<Marker> safePointsMarkers = {};
  Set<Marker> touristicPointsMarkers = {};
  BitmapDescriptor dangerMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor safeMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor touristicMarkerIcon = BitmapDescriptor.defaultMarker;
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

// initial filters (show Data-Driven Styling map boundaries, danger-points, safe-points and tourists-points)
  final List<bool> _selectedFilters = <bool>[false, true, true, false];

// visual of ToggleButtons
  static const List<Widget> filters = <Widget>[
    Icon(Icons.color_lens),
    Icon(Icons.notification_important),
    Icon(Icons.health_and_safety),
    Icon(Icons.info),
  ];

  Future<void> showInformationDialog(
      LatLng latLng, BuildContext context) async {
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
              title: const Text('Create Danger-Point'),
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
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: const Text('Submit'),
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Adding a DangerPoint...')),
                      );
                      // create a DangerPoint with given data
                      createDangerPoint(
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

  Future<void> createDangerPoint(LatLng latLng, DangerPoints pointType,
      String title, String description) async {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "$pointType-$latitude-$longitude-$title";
    var votes = 0;

    // change a marker according to type of dangerous-point
    await getBytesFromAsset(pointType.markerSrc, 150).then((onValue) {
      dangerMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

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
  }

// set visibility of different types of points on the map, based on current settings
  updatePointsVisibility() {
    if (_selectedFilters[1]) {
      // show danger points
      currentlyActiveMarkers =
          currentlyActiveMarkers.union(dangerPointsMarkers);
    } else {
      // hide danger points
      currentlyActiveMarkers =
          currentlyActiveMarkers.difference(dangerPointsMarkers);
    }
    if (_selectedFilters[2]) {
      // show safe points
      currentlyActiveMarkers = currentlyActiveMarkers.union(safePointsMarkers);
    } else {
      // hide safe points
      currentlyActiveMarkers =
          currentlyActiveMarkers.difference(safePointsMarkers);
    }
    if (_selectedFilters[3]) {
      // show touristic points
      currentlyActiveMarkers =
          currentlyActiveMarkers.union(touristicPointsMarkers);
    } else {
      // hide touristic points
      currentlyActiveMarkers =
          currentlyActiveMarkers.difference(touristicPointsMarkers);
    }
  }

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
}
