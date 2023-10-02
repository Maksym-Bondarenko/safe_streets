import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/manual_points_service.dart';
import '../../shared/points_types.dart';
import '../infowindow/point_infowindow.dart';

/// Window for a custom Point (DangerPoint or InformationPoint)
/// after providing all information regarding Point, it will be created and putted on the map with a Custom Info-Window
class PointCreationWindow extends StatefulWidget {
  final LatLng latLng;
  final Function(Marker) updateMarkers;
  final Function(PointInfoWindow) onTapCallback;

  const PointCreationWindow({
    super.key,
    required this.latLng,
    required this.updateMarkers,
    required this.onTapCallback,
  });

  @override
  _PointCreationWindowState createState() => _PointCreationWindowState();
}

class _PointCreationWindowState extends State<PointCreationWindow> {
  // service for operating the manual points and backend endpoints
  final manualPointsService = ManualPointsService();

  // key for the Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // main custom point-type (DangerPoint or InformationPoint)
  var _mainType = MainType.dangerPoint;
  late Color mainColor = Colors.black;

  // sub-type of custom point (hang on `_mainType`)
  late List<MapPoint> _subPointTypes = DangerPoint.values;
  late MapPoint _subType = _subPointTypes.first;

  // for Point Title
  final TextEditingController titleController = TextEditingController(text: "");

  // for Point Description
  final TextEditingController descriptionController =
      TextEditingController(text: "");

  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    setState(() {
      mainColor = Color.fromRGBO(
          _subType.colorR, _subType.colorG, _subType.colorB, 1.0);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // set values of `_subType` according to selected `_mainType`
  void _onMainPointTypeSelected(MainType? newValue) {
    setState(() {
      _mainType = newValue!;
      switch (_mainType) {
        case MainType.dangerPoint:
          _subPointTypes = DangerPoint.values;
          _subType = _subPointTypes.first;
          break;
        case MainType.recommendationPoint:
          _subPointTypes = RecommendationPoint.values;
          _subType = _subPointTypes.first;
          break;
        default:
          _subPointTypes = DangerPoint.values;
          _subType = _subPointTypes.first;
          break;
      }
      // set the color
      mainColor = Color.fromRGBO(
          _subType.colorR, _subType.colorG, _subType.colorB, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Create a Point',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: mainColor),
              ),
            ),
            const SizedBox(height: 10),

            // Drop-downs and text-fields
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildMainTypeDropdown(),
                    _buildSubTypeDropdown(),
                    _buildTitleTextField(),
                    _buildDescriptionTextField(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Submit-button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSubmitButton(context),
            ),
          ],
        ),
      ),
    );
  }

  // Drop-down with selecting of main point-type
  Widget _buildMainTypeDropdown() {
    // forbid choosing 'safePoint' as a manual Point-Type
    final allowedTypes =
        MainType.values.where((type) => type != MainType.safePoint);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: DropdownButton<MainType>(
            value: _mainType,
            hint: const Text('Select Point-type'),
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 15,
            underline: Container(
              height: 2,
              color: Colors.tealAccent,
            ),
            items: allowedTypes.map<DropdownMenuItem<MainType>>(
              (MainType value) {
                return DropdownMenuItem<MainType>(
                  value: value,
                  child: Text(value.name),
                );
              },
            ).toList(),
            onChanged: (MainType? value) {
              setState(() {
                _mainType = value!;
                _onMainPointTypeSelected(value);
              });
            },
          ),
        ),
      ],
    );
  }

  // Drop-down with selecting of point sub-type (based on main type)
  Widget _buildSubTypeDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: DropdownButton<MapPoint>(
            value: _subType,
            hint: const Text('Select sub-type'),
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 15,
            underline: Container(
              height: 2,
              color: Colors.tealAccent,
            ),
            items: _subPointTypes.map<DropdownMenuItem<MapPoint>>(
              (MapPoint value) {
                return DropdownMenuItem<MapPoint>(
                  value: value,
                  child: Text(value.name),
                );
              },
            ).toList(),
            onChanged: (MapPoint? value) {
              setState(() {
                _subType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  // Textual Field for Point Title
  Widget _buildTitleTextField() {
    return TextFormField(
      controller: titleController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please, enter the title";
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Enter the Title"),
    );
  }

  // Textual Field for Point Description
  Widget _buildDescriptionTextField() {
    return TextFormField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 6,
      decoration: const InputDecoration(hintText: "Enter the Description"),
    );
  }

  // Submit Point Button
  // TODO: fix (after submitting the dialog is not closing)
  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 60.0,
        width: 150.0,
        child: GestureDetector(
          onTap: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Adding a ${_subType.name}...')),
              );
              manualPointsService
                  .createAndSavePoint(
                widget.latLng,
                _mainType,
                _subType,
                titleController.value.text,
                descriptionController.value.text,
                widget.updateMarkers,
                widget.onTapCallback,
              )
                  .then((_) {
                // Close the dialog
                Navigator.of(context).pop();
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Something went wrong...')),
                );
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Create",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
