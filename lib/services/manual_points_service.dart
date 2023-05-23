import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_streets/services/base_service.dart';
import 'package:http/http.dart' as http;

import '../shared/global_functions.dart';
import '../shared/points_types.dart';

/// Service for fetching the manual (Danger- and Recommendations-) points
class ManualPointsService extends BaseService {
  // TODO: put here functionality to fetch and create ManualPoint's

  // BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;
  //
  // Future<void> createAndSavePoint(LatLng latLng, MainType mainType,
  //     MapPoint subType, String title, String description) async {
  //   var latitude = latLng.latitude;
  //   var longitude = latLng.longitude;
  //   var markerId = "$mainType-$subType-$latitude-$longitude-$title";
  //   var votes = 0;
  //
  //   // change a marker according to type of dangerous-point
  //   await getBytesFromAsset(subType.markerSrc, 200).then((onValue) {
  //     customMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
  //   });
  //
  //   // TODO: somehow replace following updating
  //   widget.updateMarkers(Marker(
  //     markerId: MarkerId(markerId),
  //     position: LatLng(latitude, longitude),
  //     icon: customMarkerIcon,
  //     onTap: () {
  //       widget.customInfoWindowController.addInfoWindow!(
  //           PointInfoWindow(
  //               mainType: _mainType,
  //               subType: _subType,
  //               title: title,
  //               description: description,
  //               votes: votes),
  //           LatLng(latitude, longitude));
  //     },
  //   ));
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   var uid = 'null';
  //   var email = 'null';
  //   var name = 'null';
  //   if (user != null) {
  //     uid = user.uid;
  //     email = user.email.toString();
  //     name = user.displayName.toString();
  //   }
  //
  //   final Map<String, dynamic> userBody = {
  //     "firebase_id": uid,
  //     "full_name": name,
  //     "email": email
  //   };
  //   // print("Current user id");
  //   // print(uid);
  //   // var url = Uri.parse("http://34.159.7.34:8080/add/place");
  //   // var url = Uri.parse("http://127.0.0.1:8080/add/place");
  //   final Map<String, dynamic> placeBody = {
  //     // "firebase_user_id": uid,
  //     "firebase_user_id": uid,
  //     "title": title,
  //     "main_type": mainType.name,
  //     "sub_type": subType.name,
  //     "comment": description,
  //     "lat": latitude,
  //     "long": longitude
  //   };
  //   //check if user is saved in the DB
  //   try {
  //     var response = await http
  //         .get(Uri.parse("http://${host}:8080/get/users?firebase_id=${uid}"));
  //
  //     // print("${response.statusCode} and body: '${response.body}'");
  //     if (response.statusCode == 200 && response.body == "[]\n") {
  //       await http.post(Uri.parse("http://${host}:8080/add/user"),
  //           headers: {"Content-Type": "application/json"},
  //           body: json.encode(userBody));
  //
  //       // print("User id ${uid} and email ${email} and name ${name}");
  //     }
  //     response = await http.post(Uri.parse("http://${host}:8080/add/place"),
  //         headers: {"Content-Type": "application/json"},
  //         body: json.encode(placeBody));
  //     // print(response.statusCode);
  //     // print(response.body);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}