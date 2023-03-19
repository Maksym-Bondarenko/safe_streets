import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:safe_streets/home/place.dart';

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

  static final LatLng _kMapGarchingCenter = LatLng(48.249521, 11.653154);

  static final CameraPosition _kInitialPosition = CameraPosition(
      target: _kMapGarchingCenter, zoom: 17.0, tilt: 0, bearing: 0);

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  Completer<GoogleMapController> _googleMapController = Completer();
  // late ClusterManager _clusterManager;
  // Set<Marker> markers = Set();

  Set<Marker> currentlyActiveMarkers = {};
  Set<Marker> dangerPointsMarkers = {};
  Set<Marker> safePointsMarkers = {};

  // add nearby police stations to the safe points


  // initial filters (show Data-Driven Styling map boundaries, danger-points, safe-points and tourists-points)
  final List<bool> _selectedFilters = <bool>[false, false, false, false];

  // visual of ToggleButtons
  static const List<Widget> filters = <Widget>[
    Icon(Icons.color_lens),
    Icon(Icons.notification_important),
    Icon(Icons.health_and_safety),
    Icon(Icons.info),
  ];

  // set visibility of different types of points on the map, based on current settings
  updatePointsVisibility() {
    // TODO: add DDS-toggling

    if (_selectedFilters[1] && _selectedFilters[2]) {
      setState(() {
        // show both safe points and danger points
        currentlyActiveMarkers = safePointsMarkers.union(dangerPointsMarkers);
      });
    }
    if (_selectedFilters[1]) {
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
  initState() {
    // change map-icon from default to custom
    getBytesFromAsset('lib/assets/marker/danger_point_marker.png', 100)
        .then((onValue) {
      dangerMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });
    // _clusterManager = ClusterManager<Place>(items, _updateMarkers,
    //     markerBuilder: _getMarkerBuilder(Colors.red));
    updatePointsVisibility();
    super.initState();
  }

  final Map<String, Marker> _policeMarkers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // set up controllers
    _googleMapController.complete(controller);
    // _clusterManager.setMapId(controller.mapId);
    customInfoWindowController.googleMapController = controller;

    getBytesFromAsset('lib/assets/marker/safe_point_marker.png', 100)
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

  // List<Place> items = [
  //   for (int i = 0; i < 10; i++)
  //     Place(
  //         name: 'Place $i',
  //         latLng: LatLng(48.848200 + i * 0.001, 2.319124 + i * 0.001)),
  //   for (int i = 0; i < 10; i++)
  //     Place(
  //         name: 'Restaurant $i',
  //         isClosed: i % 2 == 0,
  //         latLng: LatLng(48.858265 - i * 0.001, 2.350107 + i * 0.001)),
  //   for (int i = 0; i < 10; i++)
  //     Place(
  //         name: 'Bar $i',
  //         latLng: LatLng(48.858265 + i * 0.01, 2.350107 - i * 0.01)),
  //   for (int i = 0; i < 10; i++)
  //     Place(
  //         name: 'Hotel $i',
  //         latLng: LatLng(48.858265 - i * 0.1, 2.350107 - i * 0.01)),
  //   for (int i = 0; i < 10; i++)
  //     Place(
  //         name: 'Test $i',
  //         latLng: LatLng(66.160507 + i * 0.1, -153.369141 + i * 0.1)),
  //   for (int i = 0; i < 10; i++)
  //     Place(
  //         name: 'Test2 $i',
  //         latLng: LatLng(-36.848461 + i * 1, 169.763336 + i * 1)),
  // ];

  // void _updateMarkers(Set<Marker> markers) {
  //   setState(() {
  //     this.markers = markers;
  //   });
  // }

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

    updateVotes(int count) {
      setState(() {
        votes = count;
      });
    }

    setState(() {
      dangerPointsMarkers.add(Marker(
        markerId: MarkerId(markerId),
        position: LatLng(latitude, longitude),
        icon: dangerMarkerIcon,
        onTap: () {
          customInfoWindowController.addInfoWindow!(
              DangerPointInfoWindow(
                  pointType: pointType, title: title, description: description, votes: votes, updateVotes: updateVotes),
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
                // onMapCreated: (GoogleMapController controller) {
                //   customInfoWindowController.googleMapController = controller;
                // },
                onMapCreated: _onMapCreated,
                onLongPress: (LatLng latLng) async =>
                    await showInformationDialog(latLng, context),
                onTap: (position) {
                  customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  // _clusterManager.onCameraMove(position);
                  customInfoWindowController.onCameraMove!();
                },
                // onCameraIdle: () {
                //   _clusterManager.updateMap();
                // },
                // onCameraMove: (position) {
                //   customInfoWindowController.onCameraMove!();
                // },
                mapType: MapType.normal,
                initialCameraPosition: _kInitialPosition,
                // markers: currentlyActiveMarkers,
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
                // child: SpeedDial(
                //   animatedIcon: AnimatedIcons.menu_close,
                //   animatedIconTheme: IconThemeData(size: 25.0),
                //   backgroundColor: Colors.pink[600],
                //   visible: true,
                //   direction: SpeedDialDirection.down,
                //   curve: Curves.bounceInOut,
                //   children: [
                //     SpeedDialChild(
                //       child: const Icon(Icons.color_lens, color: Colors.white),
                //       backgroundColor: Colors.pink,
                //       onTap: () => print('Pressed Read Later'),
                //       label: 'Data Driven Styling',
                //       labelStyle: const TextStyle(
                //           fontWeight: FontWeight.w500, color: Colors.white),
                //       labelBackgroundColor: Colors.black,
                //     ),
                //     SpeedDialChild(
                //       child: const Icon(Icons.notification_important,
                //           color: Colors.white),
                //       backgroundColor: Colors.pink,
                //       onTap: () => print('Pressed Write'),
                //       label: 'Danger Points',
                //       labelStyle: const TextStyle(
                //           fontWeight: FontWeight.w500, color: Colors.white),
                //       labelBackgroundColor: Colors.black,
                //     ),
                //     SpeedDialChild(
                //       child: const Icon(Icons.health_and_safety,
                //           color: Colors.white),
                //       backgroundColor: Colors.pink,
                //       onTap: () => print('Pressed Code'),
                //       label: 'Safe Places',
                //       labelStyle: const TextStyle(
                //           fontWeight: FontWeight.w500, color: Colors.white),
                //       labelBackgroundColor: Colors.black,
                //     ),
                //     SpeedDialChild(
                //       child: const Icon(Icons.info, color: Colors.white),
                //       backgroundColor: Colors.pink,
                //       onTap: () => print('Pressed Code'),
                //       label: 'Touristic Info',
                //       labelStyle: const TextStyle(
                //           fontWeight: FontWeight.w500, color: Colors.white),
                //       labelBackgroundColor: Colors.black,
                //     ),
                //   ],
                // ),
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
                        });
                        updatePointsVisibility();
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.pink[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.pink[200],
                      color: Colors.pink[400],
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
            ]),
          ),
        ),
      ),
    );
  }


  // // for points clustering feature
  // Future<Marker> Function(Cluster<Place>) _getMarkerBuilder(Color color) =>
  //     (cluster) async {
  //       return Marker(
  //         markerId: MarkerId(cluster.getId()),
  //         position: cluster.location,
  //         onTap: () {
  //           print('---- $cluster');
  //           cluster.items.forEach((p) => print(p));
  //         },
  //         icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75, color,
  //             text: cluster.isMultiple ? cluster.count.toString() : null),
  //       );
  //     };
  //
  // Future<BitmapDescriptor> _getMarkerBitmap(int size, Color color,
  //     {String? text}) async {
  //   if (kIsWeb) size = (size / 2).floor();
  //
  //   final PictureRecorder pictureRecorder = PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final Paint paint1 = Paint()..color = color;
  //   final Paint paint2 = Paint()..color = Colors.white;
  //
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
  //
  //   if (text != null) {
  //     TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
  //     painter.text = TextSpan(
  //       text: text,
  //       style: TextStyle(
  //           fontSize: size / 3,
  //           color: Colors.white,
  //           fontWeight: FontWeight.normal),
  //     );
  //     painter.layout();
  //     painter.paint(
  //       canvas,
  //       Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
  //     );
  //   }
  //
  //   final img = await pictureRecorder.endRecording().toImage(size, size);
  //   final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
  //
  //   return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  // }
}
