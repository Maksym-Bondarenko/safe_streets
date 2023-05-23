// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:safe_streets/services/base_service.dart';
//
// /// Service for building a path between two geopoints via Google Path API
// class PathService extends StatefulWidget {
//   PathService({Key key}) : super(key: key);
//
//   @override
//   _PathService createState() => _PathServiceState();
// }
//
// class _PathServiceState extends State<PathService> {
//   // TODO: service for getting a safe-path between two geopoints
//
//   GoogleMapController mapController;
//   TextEditingController departureController = new TextEditingController();
//   TextEditingController arrivalController = new TextEditingController();
//   List<Marker> markersList = [];
//   GoogleMapsPlaces _places = GoogleMapsPlaces(
//     apiKey: apiKey
//   );
//   GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(
//     apiKey: apiKey
//   );
//   final List<Polyline> polyline = [];
//   List<LatLng> routeCoords = [];
//
//   PlaceDetails departure;
//   PlaceDetails arrival;
//
//   Future<Null> displayPrediction(Prediction p) async {
//     if (p != null) {
//       // get details (lat/lng)
//       PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
//       final lat = detail.result.geometry.location.lat;
//       final lng = detail.result.geometry.location.lng;
//
//       setState(() {
//         placeController.text = detail.result.name;
//         Marker marker = Marker(
//           markerId: MarkerId('arrivalMarker'),
//           draggable: false,
//           infoWindow: InfoWindow(
//             title: "This is what you searched",
//           ),
//           position: LatLng(lat, lng),
//         );
//         markersList.add(marker);
//       });
//     }
//   }
//
//   // draw the route
//   GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(
//     apiKey: apiKey
//   );
//   final List<Polyline> polyline = [];
//   List<LatLng> routeCoords = [];
//
//   computePath() async {
//     LatLng origin = new LatLng(
//       departure.geometry.location.lat,
//       departure.geometry.location.lng
//     );
//     LatLng end = new LatLng(
//         arrival.geometry.location.lat,
//         arrival.geometry.location.lng
//     );
//
//     routeCords.addAll(
//         await googleMapPolyline.getCoordinatesWithLocation(
//           origin: origin,
//           destination: end,
//           mode: RouteMode.driving
//         )
//     );
//
//     setState(() {
//       polyline.add(Polyline(
//         polylineId: PolylineId('iter'),
//         visible: true,
//         points: routeCoords,
//         width: 4,
//         color: Colors.blue,
//         startCap: Cap.roundCap,
//         endCap: Cap.buttCap,
//       ));
//     });
//   }
// }