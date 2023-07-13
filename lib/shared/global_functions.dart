import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Collection of global functions, that are used across the application

// change default google-marker-icon to custom one
Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      ?.buffer
      .asUint8List();
}

// Method for retrieving the current location
Future<Position> getCurrentLocation(GoogleMapController? googleMapController) async {
  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print('CURRENT POS: $position');
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        ),
      ),
    );
    return position;
  } catch (e) {
    throw e;
  }
}

Future<List<Placemark>> getAddresses(Position currentPosition) async {
  List<Placemark> places = await placemarkFromCoordinates(
      currentPosition.latitude, currentPosition.longitude);

  return places;
}

String? getUserId() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  return user?.uid;
}

String? getCreatorIdOfPoint(String pointId) {
  // TODO: backend call
  return FirebaseAuth.instance.currentUser?.uid;
}