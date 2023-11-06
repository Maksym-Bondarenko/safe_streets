// import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:safe_streets/services/safe_points_service.dart';
// import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/views/map/widgets/base_map.dart';
import 'package:safe_streets/views/map/widgets/map_control_buttons.dart';
import 'package:safe_streets/views/map/widgets/map_search_bar.dart';
import 'package:safe_streets/views/map/widgets/safety_info_sheet.dart';
import 'package:safe_streets/views/map/widgets/sos_menu.dart';
// import 'package:safe_streets/widgets/dialog_window.dart';// import 'package:safe_streets/widgets/loading_spinner.dart';

/// Main Page with the FilterMarkers-Map, including 3 types of Points
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

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
    final marginBottom = screen.height * 0.21;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BaseMap(setMapController: _setMapController),
            Positioned(
              left: marginHorizontal,
              right: marginHorizontal,
              top: marginHorizontal,
              child: MapSearchBar(
                onSubmit: (query) {},
              ),
            ),
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
            // Positioned(
            //   top: 30,
            //   left: 10,
            //   child: _buildToggleButtons(),
            // ),
            SafetyInfoSheet(
              locationName: 'Freimann',
              safetyLabel: 'Safe',
              safetyDescription:
                  'A lot of pickpocketing happens in this area. Make sure to keep an eye on your belongings.',
              safetyRating: 4.5,
              onPressed: () {},
            ),
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
      customInfoWindowController.googleMapController = _googleMapController;
    });
  }
}
