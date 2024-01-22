import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/models/safety_info.dart';
import 'package:safe_streets/router.dart';
import 'package:safe_streets/services/safety_info.dart';
import 'package:safe_streets/utils/global_functions.dart';
import 'package:safe_streets/views/map/widgets/base_map.dart';
import 'package:safe_streets/views/map/widgets/map_control_buttons.dart';
import 'package:safe_streets/views/map/widgets/map_search_bar.dart';
import 'package:safe_streets/views/map/widgets/safety_info_sheet.dart';
import 'package:safe_streets/views/map/widgets/sos_menu.dart';
// import 'package:safe_streets/widgets/dialog_window.dart';
// import 'package:safe_streets/widgets/loading_spinner.dart';

/// Main Page with the FilterMarkers-Map, including 3 types of Points
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final SafetyInfoService _safetyInfoService;
  GoogleMapController? _googleMapController;
  Position? _currentPosition;
  Position? _selectedPosition;
  String? _locationName;
  SafetyInfo? _safetyInfo;

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    _safetyInfoService = SafetyInfoService();
  }

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
                onSubmit: _onSearchSubmit,
              ),
            ),
            Positioned(
              bottom: marginBottom,
              right: marginHorizontal,
              child: MapControlButtons(
                googleMapController: _googleMapController,
                onUpdateCurrentLocation: _updateCurrentLocation,
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
              locationName: _locationName,
              safetyInfo: _safetyInfo,
              onPressed: _goToRoutePage,
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

  void _setMapController(GoogleMapController controller) async {
    setState(() {
      _googleMapController = controller;
      customInfoWindowController.googleMapController = _googleMapController;
      _locatePosition();
    });
  }

  Future<void> _locatePosition() async {
    final position = await getCurrentLocation(_googleMapController);
    await _updateCurrentLocation(position);
  }

  Future<void> _updateCurrentLocation(Position position) async {
    await _updateSelectedLocation(position);
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _updateSelectedLocation(Position position) async {
    await _updateSafetyInfo(position);
    final place = await _getPlace(position);
    setState(() {
      _selectedPosition = position;
      _locationName = place.subLocality ?? place.locality ?? '---';
    });
  }

  Future<Placemark> _getPlace(Position position) async {
    return (await placemarkFromCoordinates(
        position.latitude, position.longitude))[0];
  }

  Future<void> _updateSafetyInfo(Position position) async {
    try {
      final safetyInfo =
          await _safetyInfoService.getSafetyInformation(position);
      setState(() {
        _safetyInfo = safetyInfo;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onSearchSubmit(String query) async {
    // await locationFromAddress(query);
    // setState
  }

  void _goToRoutePage() {
    AppRouter.router.pushNamed(AppRoutes.route);
  }

  // void onSearchSubmit(String query) async {
  //   try {
  //   final position = await getCurrentLocation(_googleMapController);
  //   setState(() {
  //     _destinationLocation = query;
  //   });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
