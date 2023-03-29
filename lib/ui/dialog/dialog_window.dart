import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:ui' as ui;

import '../infowindow/point_infowindow.dart';
import '../infowindow/points_types.dart';

// opens a Dialog-Window for creating a custom Point (DangerPoint or InformationPoint)
// each Point-type has different sub-types
// after providing all information regarding Point, it will be created and putted on the map with a Custom Info-Window
class CreatePointWindow extends StatefulWidget {
  final LatLng latLng;
  final CustomInfoWindowController customInfoWindowController;
  final Function(Marker) updateMarkers;

  const CreatePointWindow(
      {super.key,
      required this.latLng,
      required this.customInfoWindowController,
      required this.updateMarkers});

  @override
  _CreatePointWindowState createState() => _CreatePointWindowState();
}

class _CreatePointWindowState extends State<CreatePointWindow> {
  // key for the Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // main custom point-type (DangerPoint or InformationPoint)
  var _mainType = MainType.dangerPoint;

  // sub-type of custom point (hang on `_mainType`)
  late List<MapPoint> _subPointTypes = DangerPoint.values;
  late MapPoint _subType = _subPointTypes.first;

  // for Point Title
  final TextEditingController titleController = TextEditingController(text: "");

  // for Point Description
  final TextEditingController descriptionController =
      TextEditingController(text: "");

  // set values of `_subType` according to selected `_mainType`
  void _onMainPointTypeSelected(MainType? newValue) {
    setState(() {
      _mainType = newValue!;
      switch (_mainType) {
        case MainType.dangerPoint:
          _subPointTypes = DangerPoint.values;
          _subType = _subPointTypes.first;
          break;
        case MainType.recommendationPoint:
          _subPointTypes = RecommendationPoint.values;
          _subType = _subPointTypes.first;
          break;
        default:
          _subPointTypes = DangerPoint.values;
          _subType = _subPointTypes.first;
          break;
      }
    });
  }

  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

  Future<void> createPoint(LatLng latLng, MainType mainType, MapPoint subType,
      String title, String description) async {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "$mainType-$subType-$latitude-$longitude-$title";
    var votes = 0;

    // change a marker according to type of dangerous-point
    await _getBytesFromAsset(subType.markerSrc, 150).then((onValue) {
      customMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    widget.updateMarkers(Marker(
      markerId: MarkerId(markerId),
      position: LatLng(latitude, longitude),
      icon: customMarkerIcon,
      onTap: () {
        widget.customInfoWindowController.addInfoWindow!(
            PointInfoWindow(
                mainType: _mainType,
                subType: _subType,
                title: title,
                description: description,
                votes: votes),
            LatLng(latitude, longitude));
      },
    ));
  }

  Future<void> createAndSavePoint(LatLng latLng, MainType mainType,
      MapPoint subType, String title, String description) async {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "$mainType-$subType-$latitude-$longitude-$title";
    var votes = 0;

    // change a marker according to type of dangerous-point
    await _getBytesFromAsset(subType.markerSrc, 150).then((onValue) {
      customMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    widget.updateMarkers(Marker(
      markerId: MarkerId(markerId),
      position: LatLng(latitude, longitude),
      icon: customMarkerIcon,
      onTap: () {
        widget.customInfoWindowController.addInfoWindow!(
            PointInfoWindow(
                mainType: _mainType,
                subType: _subType,
                title: title,
                description: description,
                votes: votes),
            LatLng(latitude, longitude));
      },
    ));
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    var uid = 'null';
    var email = 'null';
    var name = 'null';
    if (user != null) {
      uid = user.uid;
      email = user.email.toString();
      name = user.displayName.toString();
    }

    final Map<String, dynamic> user_body = {
      "firebase_id": uid,
      "full_name": name,
      "email": email
    };
    // print("Current user id");
    // print(uid);
    // var url = Uri.parse("http://34.89.222.17:8080/add/place");
    // var url = Uri.parse("http://127.0.0.1:8080/add/place");
    final Map<String, dynamic> place_body = {
      // "firebase_user_id": uid,
      "firebase_user_id": uid,
      "title": title,
      "main_type": mainType.name,
      "sub_type": subType.name,
      "comment": description,
      "lat": latitude,
      "long": longitude
    };
    //check if user is saved in the DB
    try {
      var host = "34.89.169.182";
      // uncomment for testing with local server
      // host = "localhost";
      var response = await http
          .get(Uri.parse("http://${host}:8080/get/users?firebase_id=${uid}"));

      // print("${response.statusCode} and body: '${response.body}'");
      if (response.statusCode == 200 && response.body == "[]\n") {
        await http.post(Uri.parse("http://${host}:8080/add/user"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(user_body));

        // print("User id ${uid} and email ${email} and name ${name}");
      }
      response = await http.post(Uri.parse("http://${host}:8080/add/place"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(place_body));
      // print(response.statusCode);
      // print(response.body);
    } catch (e) {
      print(e);
    }
  }

  // change default google-marker-icon to custom one
  static Future<Uint8List?> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Create a Point'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // drop-down with selecting main type of point (danger or information)
            Row(children: [
              DropdownButton<MainType>(
                value: _mainType,
                hint: const Text('Select Point-type'),
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 15,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                items: MainType.values
                    .map<DropdownMenuItem<MainType>>((MainType value) {
                  int index = value.index;
                  return DropdownMenuItem<MainType>(
                    value: value,
                    enabled: MainTypeDetails.enabledCustomPoints[index],
                    child: Text(value.name),
                  );
                }).toList(),
                onChanged: (MainType? value) {
                  setState(() {
                    _mainType = value!;
                    _onMainPointTypeSelected(value);
                  });
                },
              ),
            ]),
            // drop-down with selecting sub-type of point (based on `_mainType`)
            Row(children: [
              DropdownButton<MapPoint>(
                value: _subType,
                hint: const Text('Select sub-type'),
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 15,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                items: _subPointTypes
                    .map<DropdownMenuItem<MapPoint>>((MapPoint value) {
                  return DropdownMenuItem<MapPoint>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
                onChanged: (MapPoint? value) {
                  setState(() {
                    _subType = value!;
                  });
                },
              ),
            ]),
            // Text-field for Title
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please, enter the title";
                }
                return null;
              },
              decoration: const InputDecoration(hintText: "Enter the Title"),
            ),
            // Text-field for Description
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              decoration:
                  const InputDecoration(hintText: "Enter the Description"),
            ),
          ],
        ),
      ),
      // submit-button and validation-logic
      actions: <Widget>[
        InkWell(
          splashColor: Colors.blue,
          onTap: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Adding a ${_subType.name}...')),
              );
              // create a DangerPoint with given data and save it in the DB
              createAndSavePoint(widget.latLng, _mainType, _subType,
                  titleController.value.text, descriptionController.value.text);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Something gone wrong...')),
              );
            }
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
