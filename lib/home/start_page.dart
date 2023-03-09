import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../src/locations.dart' as locations;

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  late GoogleMapController mapController;

  // for google-offices locations
  final Map<String, Marker> _markers = {};

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  initState() {
    // change map-icon from default to custom
    addCustomIcon();
    super.initState();
  }

  // change default google-marker-icon to custom one
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "lib/assets/danger_point_marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  static final LatLng _kMapGarchingCenter = LatLng(48.249521, 11.653154);

  static final CameraPosition _kInitialPosition = CameraPosition(
      target: _kMapGarchingCenter, zoom: 17.0, tilt: 0, bearing: 0);

  Set<Marker> _createMarker() {
    return {
      Marker(
          markerId: MarkerId("marker_1"),
          position: _kMapGarchingCenter,
          infoWindow: InfoWindow(title: 'Dangerous Place'),
          rotation: 90),
      Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(48.262330, 11.668564),
        infoWindow: InfoWindow(title: 'Very Dangerous Place!!!'),
      ),
    };
  }

  Set<Marker> customMarkers = {};

  void createCustomMarker(LatLng latLng) {
    var latitude = latLng.latitude;
    var longitude = latLng.longitude;
    var markerId = "marker_$latitude-$longitude";

    setState(() {
      customMarkers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(latitude, longitude),
          infoWindow: const InfoWindow(
              title: 'Custom Marker',
              snippet: 'some snippet-text',
          ),
          icon: markerIcon,
        )
      );
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
        body: Stack(alignment: AlignmentDirectional.topEnd, children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onLongPress: (LatLng latLng) => createCustomMarker(latLng),
            mapType: MapType.normal,
            initialCameraPosition: _kInitialPosition,
            // markers: _markers.values.toSet(),
            // markers: _createMarker(),
            markers: customMarkers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
          ),
        ]),
      ),
    );
  }
}
