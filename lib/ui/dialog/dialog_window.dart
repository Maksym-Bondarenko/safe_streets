import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../../shared/global_functions.dart';
import '../infowindow/point_infowindow.dart';
import '../../shared/points_types.dart';

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

  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

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

  // TODO: rewrite
  Future<void> createAndSavePoint(LatLng latLng, MainType mainType,
      MapPoint subType, String title, String description) async {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "$mainType-$subType-$latitude-$longitude-$title";
    var votes = 0;

    // change a marker according to type of dangerous-point
    await getBytesFromAsset(subType.markerSrc, 200).then((onValue) {
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

    final Map<String, dynamic> userBody = {
      "firebase_id": uid,
      "full_name": name,
      "email": email
    };
    // print("Current user id");
    // print(uid);
    // var url = Uri.parse("http://34.159.7.34:8080/add/place");
    // var url = Uri.parse("http://127.0.0.1:8080/add/place");
    final Map<String, dynamic> placeBody = {
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
      var host = "34.159.7.34";
      // TODO: uncomment following line for testing with local server
      host = "localhost";
      var response = await http
          .get(Uri.parse("http://${host}:8080/get/users?firebase_id=${uid}"));

      // print("${response.statusCode} and body: '${response.body}'");
      if (response.statusCode == 200 && response.body == "[]\n") {
        await http.post(Uri.parse("http://${host}:8080/add/user"),
            headers: {"Content-Type": "application/json"},
            body: json.encode(userBody));

        // print("User id ${uid} and email ${email} and name ${name}");
      }
      response = await http.post(Uri.parse("http://${host}:8080/add/place"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(placeBody));
      // print(response.statusCode);
      // print(response.body);
    } catch (e) {
      print(e);
    }
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
            _buildMainTypeDropdown(),
            _buildSubTypeDropdown(),
            _buildTitleTextField(),
            _buildDescriptionTextField(),
          ],
        ),
      ),
      actions: <Widget>[
        _buildSubmitButton(context),
      ],
    );
  }

  // Drop-down with selecting of main point-type
  Widget _buildMainTypeDropdown() {
    // forbid choosing 'safePoint' as a manual Point-Type
    final allowedTypes = MainType.values.where((type) => type != MainType.safePoint);

    return Row(
      children: [
        DropdownButton<MainType>(
          value: _mainType,
          hint: const Text('Select Point-type'),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 15,
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
          items: allowedTypes.map<DropdownMenuItem<MainType>>(
                (MainType value) {
              return DropdownMenuItem<MainType>(
                value: value,
                child: Text(value.name),
              );
            },
          ).toList(),
          onChanged: (MainType? value) {
            setState(() {
              _mainType = value!;
              _onMainPointTypeSelected(value);
            });
          },
        ),
      ],
    );
  }

  // Drop-down with selecting of point sub-type (based on main type)
  Widget _buildSubTypeDropdown() {
    return Row(
      children: [
        DropdownButton<MapPoint>(
          value: _subType,
          hint: const Text('Select sub-type'),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 15,
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
          items: _subPointTypes.map<DropdownMenuItem<MapPoint>>(
                (MapPoint value) {
              return DropdownMenuItem<MapPoint>(
                value: value,
                child: Text(value.name),
              );
            },
          ).toList(),
          onChanged: (MapPoint? value) {
            setState(() {
              _subType = value!;
            });
          },
        ),
      ],
    );
  }

  // Textual Field for Point Title
  Widget _buildTitleTextField() {
    return TextFormField(
      controller: titleController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please, enter the title";
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Enter the Title"),
    );
  }

  // Textual Field for Point Description
  Widget _buildDescriptionTextField() {
    return TextFormField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      decoration: const InputDecoration(hintText: "Enter the Description"),
    );
  }

  // Submit Point Button
  Widget _buildSubmitButton(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      onTap: () {
        if (formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Adding a ${_subType.name}...')),
          );
          createAndSavePoint(
            widget.latLng,
            _mainType,
            _subType,
            titleController.value.text,
            descriptionController.value.text,
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something gone wrong...')),
          );
        }
      },
      child: const Text("Submit"),
    );
  }
}
