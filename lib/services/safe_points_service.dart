import 'dart:convert';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_streets/services/base_service.dart';
import 'package:http/http.dart' as http;

import '../shared/global_functions.dart';
import '../shared/points_types.dart';
import '../ui/infowindow/point_infowindow.dart';

/// Service for getting SAfePoints from the backend and showing them on the map
class SafePointsService extends BaseService {
  // TODO: put here functionality to fetch the SafePoint's from the backend on the map

  // final CustomInfoWindowController customInfoWindowController =
  //     CustomInfoWindowController();
  //
  // BitmapDescriptor safeMarkerIcon = BitmapDescriptor.defaultMarker;
  //
  // Set<Marker> currentlyActiveMarkers = {};
  // Set<Marker> dangerPointsMarkers = {};
  // Set<Marker> safePointsMarkers = {};
  // Set<Marker> recommendationPointsMarkers = {};
  //
  // final Map<String, Marker> _policeMarkers = {};
  // final Set<Marker> _dangerPointsMarkers = {};
  // final Set<Marker> _safePointsMarkers = {};
  // final Set<Marker> _recommendationPointsMarkers = {};
  //
  // Future<void> fetchSafePoints() async {
  //   // fetch safePoints (police stations) and custom points (DangerPoint and RecommendationPoint)
  //   var policeStations = [];
  //   const munichCenterLat = 48.1351;
  //   const munichCenterLong = 11.582;
  //   try {
  //     final response = await http.get(Uri.parse(
  //         "https://maps.googleapis.com/maps/api/place/search/json?location=${munichCenterLat},${munichCenterLong}8&rankby=distance&types=police&sensor=false&key=${apiKey}"));
  //     policeStations = json.decode(response.body)["results"];
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   var points = [];
  //   try {
  //     final response =
  //         await http.get(Uri.parse("http://${host}:8080/get/all_places"));
  //     if (response.statusCode == 200) {
  //       points = json.decode(response.body);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   // clear all markers
  //   _policeMarkers.clear();
  //   _dangerPointsMarkers.clear();
  //   _safePointsMarkers.clear();
  //   _recommendationPointsMarkers.clear();
  //
  //   for (final policeStation in policeStations) {
  //     var id = policeStation["place_id"];
  //     var latitude = policeStation["geometry"]["location"]["lat"];
  //     var longitude = policeStation["geometry"]["location"]["lng"];
  //     var address = policeStation["vicinity"];
  //     var name = policeStation["name"];
  //     print(
  //         "NAME ${name} ADDRESS ${address} lat ${latitude} long ${longitude}");
  //     final marker = Marker(
  //         markerId: MarkerId(id),
  //         position: LatLng(latitude, longitude),
  //         icon: safeMarkerIcon,
  //         onTap: () => {
  //               customInfoWindowController.addInfoWindow!(
  //                   PointInfoWindow(
  //                       mainType: MainType.safePoint,
  //                       subType: SafePoint.police,
  //                       title: name,
  //                       description: "Address: ${address}",
  //                       votes: 0),
  //                   LatLng(latitude, longitude))
  //             });
  //
  //     // add each police-office
  //     _policeMarkers[name] = marker;
  //     // add police stations to set of safe points
  //     safePointsMarkers.addAll(_policeMarkers.values.toSet());
  //   }
  //
  //   // add all custom made points (DangerPoints and RecommendationPoints)
  //   for (final point in points) {
  //     var mainType = getMainType(point["main_type"]);
  //     var subType = getSubType(point["sub_type"], point["main_type"]);
  //     var latLng =
  //         LatLng(double.parse(point["lat"]), double.parse(point["long"]));
  //     var latitude = latLng.latitude;
  //     var longitude = latLng.longitude;
  //     var title = point["title"];
  //     var description = point["comment"];
  //     var markerId = "$mainType-$subType-$latitude-$longitude-$title";
  //     var customMarkerIcon = BitmapDescriptor.defaultMarker;
  //     await getBytesFromAsset(subType.markerSrc, 150).then((onValue) {
  //       customMarkerIcon = BitmapDescriptor.fromBytes(onValue!);
  //     });
  //
  //     final marker = Marker(
  //         markerId: MarkerId(markerId),
  //         position: latLng,
  //         icon: customMarkerIcon,
  //         onTap: () => {
  //               customInfoWindowController.addInfoWindow!(
  //                   PointInfoWindow(
  //                       mainType: mainType,
  //                       subType: subType,
  //                       title: title,
  //                       description: description,
  //                       votes: 0),
  //                   latLng)
  //             });
  //
  //     // add teach point to the set
  //     switch (mainType) {
  //       case MainType.dangerPoint:
  //         _dangerPointsMarkers.add(marker);
  //         break;
  //       case MainType.recommendationPoint:
  //         _recommendationPointsMarkers.add(marker);
  //         break;
  //       case MainType.safePoint:
  //         _safePointsMarkers.add(marker);
  //     }
  //   }
  //
  //   //add prefetched points from the DB to the map
  //   dangerPointsMarkers.addAll(_dangerPointsMarkers);
  //   safePointsMarkers.addAll(_safePointsMarkers);
  //   recommendationPointsMarkers.addAll(_recommendationPointsMarkers);
  // }
}
