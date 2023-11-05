import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/services/manual_points_service.dart';
import 'package:safe_streets/utils/points_types.dart';

/// Class creates a Dialog-Window for a custom Point (DangerPoint or InformationPoint)
/// after providing all information regarding Point, it will be created and putted on the map with a Custom Info-Window
class DialogWindow extends StatefulWidget {
  final LatLng latLng;
  final CustomInfoWindowController customInfoWindowController;
  final Function(Marker) updateMarkers;

  const DialogWindow(
      {super.key,
      required this.latLng,
      required this.customInfoWindowController,
      required this.updateMarkers});

  @override
  State<DialogWindow> createState() => _DialogWindowState();
}

class _DialogWindowState extends State<DialogWindow> {
  // service for operating the manual points and backend endpoints
  final manualPointsService = ManualPointsService();

  // key for the Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // main custom point-type (DangerPoint or InformationPoint)
  var _mainType = MainType.dangerPoint;

  // sub-type of custom point (hang on `_mainType`)
  late List<MapPoint> _subPointTypes = DangerPoint.values;
  late MapPoint _subType = _subPointTypes.first;

  // for Point Title
  final TextEditingController titleController = TextEditingController(text: "");

  // for Point Description
  final TextEditingController descriptionController =
      TextEditingController(text: "");

  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Create a Point'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildMainTypeDropdown(),
            _buildSubTypeDropdown(),
            _buildTitleTextField(),
            _buildDescriptionTextField(),
          ],
        ),
      ),
      actions: <Widget>[
        _buildSubmitButton(context),
      ],
    );
  }

  // Drop-down with selecting of main point-type
  Widget _buildMainTypeDropdown() {
    // forbid choosing 'safePoint' as a manual Point-Type
    final allowedTypes =
        MainType.values.where((type) => type != MainType.safePoint);

    return Row(
      children: [
        DropdownButton<MainType>(
          value: _mainType,
          hint: const Text('Select Point-type'),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 15,
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
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
      ],
    );
  }

  // Drop-down with selecting of point sub-type (based on main type)
  Widget _buildSubTypeDropdown() {
    return Row(
      children: [
        DropdownButton<MapPoint>(
          value: _subType,
          hint: const Text('Select sub-type'),
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 15,
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
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
      minLines: 1,
      maxLines: 5,
      decoration: const InputDecoration(hintText: "Enter the Description"),
    );
  }

  // Submit Point Button
  // TODO: fix (after submitting the dialog is not closing)
  Widget _buildSubmitButton(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
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
            widget.customInfoWindowController,
            widget.updateMarkers,
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
      child: const Text("Submit"),
    );
  }
}
