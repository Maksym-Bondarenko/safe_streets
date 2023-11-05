// import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:safe_streets/services/safe_points_service.dart';
// import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/views/map/widgets/base_map.dart';
import 'package:safe_streets/views/map/widgets/map_control_buttons.dart';
import 'package:safe_streets/views/map/widgets/sos_menu.dart';
// import 'package:safe_streets/widgets/dialog_window.dart';
// import 'package:safe_streets/views/map/widgets/path_search.dart';
// import 'package:safe_streets/widgets/loading_spinner.dart';

/// Main Page with the FilterMarkers-Map, including 3 types of Points
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _googleMapController;

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final marginHorizontal = screen.width * 0.05;
    final marginBottom = screen.height * 0.1;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BaseMap(setMapController: _setMapController),

            // Route-builder enables searching for points and building a navigation path between them
            // PathSearch(
            //   googleMapController: _googleMapController,
            // onPathDataReceived: onPathDataReceived,
            // ),

            Positioned(
              bottom: marginBottom,
              right: marginHorizontal,
              child: MapControlButtons(
                googleMapController: _googleMapController,
              ),
            ),
            Positioned(
              bottom: marginBottom,
              left: marginHorizontal,
              child: const SOSMenu(),
            ),

            //   // Toggle Buttons
            //   Positioned(
            //     top: 30,
            //     left: 10,
            //     child: _buildToggleButtons(),
            //   ),

            // Custom Info Window
            CustomInfoWindow(
              controller: customInfoWindowController,
              width: 300,
              height: 300,
              offset: 50,
            ),
          ],
        ),
      ),
    );
  }

  void _setMapController(GoogleMapController controller) {
    setState(() {
      _googleMapController = controller;
    });
  }
}
