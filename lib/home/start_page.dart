import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Safe Streets Maps'),
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );

    // return Scaffold(
    //   body: Container(
    //     padding: const EdgeInsets.all(20),
    //     child: const Placeholder(color: Colors.orangeAccent),
    //   ),
    // );
  }
  
}