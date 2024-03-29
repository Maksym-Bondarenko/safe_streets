import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:safe_streets/services/base_service.dart';
import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/utils/points_types.dart';
import 'package:safe_streets/widgets/point_info_window.dart';

/// Service for getting SafePoints from the backend and showing them on the map
class SafePointsService extends BaseService {
  /// get all police stations by current parameters (Lat, Long)
  /// via google-places-api
  Future<List<dynamic>> fetchPoliceStations() async {
    List<dynamic> policeStations = [];

    try {
      final response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/search/json?location=${munichCenterLat},${munichCenterLong}8&rankby=distance&types=police&sensor=false&key=${apiKey}"));
      policeStations = json.decode(response.body)["results"];
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch police stations");
    }

    return policeStations;
  }

  /// get all custom points from the backend
  Future<List<dynamic>> fetchCustomPoints() async {
    List<dynamic> customPoints = [];

    try {
      final response =
          await http.get(Uri.parse("http://${host}:8080/get/all_places"));
      if (response.statusCode == 200) {
        customPoints = json.decode(response.body);
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch custom points");
    }

    return customPoints;
  }

  /// returns the marker of police station with filled data
  Future<Marker> getPoliceMarker(
      policeStation, customInfoWindowController) async {
    // TODO: fix bug (does not change the marker to SafePoint, shows original one)
    BitmapDescriptor safeMarkerIcon = BitmapDescriptor.defaultMarker;

    // set icon to SafePoint
    getBytesFromAsset('assets/markers/safe_points/safe_point_marker.png', 200)
        .then((onValue) {
      safeMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    var id = policeStation["place_id"];
    var latitude = policeStation["geometry"]["location"]["lat"];
    var longitude = policeStation["geometry"]["location"]["lng"];
    var address = policeStation["vicinity"];
    var name = policeStation["name"];
    print("NAME ${name} ADDRESS ${address} lat ${latitude} long ${longitude}");
    final marker = Marker(
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
        icon: safeMarkerIcon,
        onTap: () => {
              customInfoWindowController.addInfoWindow!(
                  PointInfoWindow(
                      mainType: MainType.safePoint,
                      subType: SafePoint.police,
                      title: name,
                      description: "Address: ${address}",
                      votes: 0),
                  LatLng(latitude, longitude))
            });

    return marker;
  }

  /// returns the custom marker with filled data
  Future<Marker> getCustomMarker(
      customPoint, customInfoWindowController) async {
    var mainType = getMainType(customPoint["main_type"]);
    var subType = getSubType(customPoint["sub_type"], customPoint["main_type"]);
    var latLng = LatLng(
        double.parse(customPoint["lat"]), double.parse(customPoint["long"]));
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var title = customPoint["title"];
    var description = customPoint["comment"];
    var markerId = "$mainType-$subType-$latitude-$longitude-$title";
    var customMarkerIcon = BitmapDescriptor.defaultMarker;
    await getBytesFromAsset(subType.markerSrc, 150).then((onValue) {
      customMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    final marker = Marker(
        markerId: MarkerId(markerId),
        position: latLng,
        icon: customMarkerIcon,
        onTap: () => {
              customInfoWindowController.addInfoWindow!(
                  PointInfoWindow(
                      mainType: mainType,
                      subType: subType,
                      title: title,
                      description: description,
                      votes: 0),
                  latLng)
            });

    return marker;
  }
}
