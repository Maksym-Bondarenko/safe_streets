import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

import '../ui/infowindow/danger_point_infowindow.dart';

import 'dart:ui' as ui;

import '../ui/infowindow/points_types.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  BitmapDescriptor dangerMarkerIcon = BitmapDescriptor.defaultMarker;

  static final LatLng _kMapGarchingCenter = LatLng(48.249521, 11.653154);

  static final CameraPosition _kInitialPosition = CameraPosition(
      target: _kMapGarchingCenter, zoom: 17.0, tilt: 0, bearing: 0);

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  @override
  initState() {
    // change map-icon from default to custom
    getBytesFromAsset('lib/assets/marker/danger_point_marker.png', 100)
        .then((onValue) {
      dangerMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });
    super.initState();
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

  Set<Marker> customMarkers = {};

  Future<void> createCustomMarker(
      LatLng latLng, DangerPoints pointType,String title, String description) async {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "$pointType-$latitude-$longitude-$title";

    // change a marker according to type of dangerous-point
    await getBytesFromAsset(pointType.markerSrc, 150)
        .then((onValue) {
      dangerMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    setState(() {
      customMarkers.add(Marker(
        markerId: MarkerId(markerId),
        position: LatLng(latitude, longitude),
        icon: dangerMarkerIcon,
        onTap: () {
          customInfoWindowController.addInfoWindow!(
              DangerPointInfoWindow(
                  pointType: pointType, title: title, description: description),
              LatLng(latitude, longitude));
        },
      ));
    });
  }

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
          bool? isChecked = false;
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
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 15,
                        style: TextStyle(color: Colors.primaries.first),
                        underline: Container(
                          height: 2,
                          color: Colors.primaries.first.shade100,
                        ),
                        items: allPointTypes.map<DropdownMenuItem<DangerPoints>>(
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
                        decoration: const InputDecoration(
                            hintText: "Enter the Description"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              "Hereby I confirm the privacy policy and willing to publish entered information.",
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Checkbox(
                              value: isChecked,
                              onChanged: (checked) {
                                setState(() {
                                  isChecked = checked;
                                });
                              })
                        ],
                      )
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: const Text('Submit'),
                  onTap: () {
                    if (formKey.currentState!.validate() && isChecked!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Adding a DangerPoint...')),
                      );
                      // create a DangerPoint with given data
                      createCustomMarker(latLng, pointType, titleController.value.text,
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

  // static const palces = {
  //   "ChIJBUUQwatznkcR8Kl2O6clHRw": 20, // Garching
  // };
  // featureLayer.style = featureStyleFunctionOptions => {
  //   const placeFeature = featureStyleFunctionOptions.feature as google.maps.PlaceFeature;
  //   const danger = states[placeFeature.placeId];
  //   let fillColor;
  //   if (danger < 25) {
  //     fillColor = 'green'
  //   } else if (danger < 50) {
  //     fillColor = 'yellow'
  //   } else if (danger < 75) {
  //     fillColor = 'orange'
  //   } else if (danger < 100) {
  //     fillColor = 'red'
  //   }
  //   return {
  //     fillColor,
  //     fillOpacity: 0.5
  //   }
  // };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Safe Streets Maps'),
          elevation: 2,
        ),
        body: Container(
          child: SafeArea(
            child: Stack(children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  customInfoWindowController.googleMapController = controller;
                },
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
                markers: customMarkers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                trafficEnabled: true,
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
            ]),
          ),
        ),
      ),
    );
  }
}
