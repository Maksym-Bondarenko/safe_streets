import 'dart:convert';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:safe_streets/services/base_service.dart';
import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/utils/points_types.dart';
import 'package:safe_streets/widgets/point_info_window.dart';

/// Service for fetching the manual (Danger- and Recommendations-) points
class ManualPointsService extends BaseService {
  Future<void> createAndSavePoint(
    LatLng latLng,
    MainType mainType,
    MapPoint subType,
    String title,
    String description,
    CustomInfoWindowController customInfoWindowController,
    Function(Marker) updateMarkers,
  ) async {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "$mainType-$subType-$latitude-$longitude-$title";
    var votes = 0;

    BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

    // change a marker according to type of dangerous-point
    await getBytesFromAsset(subType.markerSrc, 200).then((onValue) {
      customMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    updateMarkers(Marker(
      markerId: MarkerId(markerId),
      position: LatLng(latitude, longitude),
      icon: customMarkerIcon,
      onTap: () {
        customInfoWindowController.addInfoWindow!(
          PointInfoWindow(
            mainType: mainType,
            subType: subType,
            title: title,
            description: description,
            votes: votes,
          ),
          LatLng(latitude, longitude),
        );
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
      "email": email,
    };

    final Map<String, dynamic> placeBody = {
      "firebase_user_id": uid,
      "title": title,
      "main_type": mainType.name,
      "sub_type": subType.name,
      "comment": description,
      "lat": latitude,
      "long": longitude,
    };

    // TODO: move all constants (urls) into the separate config-files
    try {
      var response = await http.get(
        Uri.parse("http://${host}:8080/get/users?firebase_id=${uid}"),
      );

      if (response.statusCode == 200 && response.body == "[]\n") {
        await http.post(
          Uri.parse("http://${host}:8080/add/user"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(userBody),
        );
      }

      response = await http.post(
        Uri.parse("http://${host}:8080/add/place"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(placeBody),
      );
    } catch (e) {
      print(e);
    }
  }
}
