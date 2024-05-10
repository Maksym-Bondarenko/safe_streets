import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/models/point.dart';
import 'package:safe_streets/services/safety.dart';
import 'package:safe_streets/widgets/dropdown_input_field.dart';
import 'package:safe_streets/widgets/primary_button.dart';
import 'package:safe_streets/widgets/text_input_field.dart';

/// Class creates a Dialog-Window for a custom point (DangerPoint or InformationPoint)
/// after providing all information regarding point, it will be created and put on the map with a Custom Info-Window
class AddCustomPointDialog extends ConsumerStatefulWidget {
  final LatLng latLng;

  const AddCustomPointDialog(
    this.latLng, {
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCustomPointDialogState();
}

class _AddCustomPointDialogState extends ConsumerState<AddCustomPointDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mainTypes = PointType.values
      .where((t) => t is! SafePointType)
      .map((t) => t.mainType)
      .toSet();

  late String _mainType = _mainTypes.first;
  late Iterable<PointType> _pointTypes = PointType.values.where(_isOfMainType);
  late PointType _pointType = _pointTypes.first;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Add a point'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusS),
        ),
        actionsPadding: const EdgeInsets.only(
          left: kSpacingM,
          right: kSpacingM,
          bottom: kSpacingM,
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputField(
                controller: _titleController,
                hintText: 'Title',
                validator: (value) => value == null || value.isEmpty
                    ? "Please, enter the title"
                    : null,
              ),
              const SizedBox(height: kSpacingS),
              DropdownInputField<String>(
                hint: const Text('Select point-type'),
                value: _mainType,
                items: _mainTypes
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: _onChangedMainType,
              ),
              const SizedBox(height: kSpacingS),
              DropdownInputField<PointType>(
                hint: const Text('Selec sub-type'),
                value: _pointType,
                items: _pointTypes
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.subType),
                      ),
                    )
                    .toList(),
                onChanged: _onChangedPointType,
              ),
              const SizedBox(height: kSpacingS),
              TextInputField(
                controller: _descriptionController,
                hintText: 'Description',
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 1,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          PrimaryButton(
            onPressed: _onSubmit,
            child: const Text("Submit"),
          ),
        ],
      );
    });
  }

  void _onChangedMainType(String? newValue) {
    setState(() {
      if (_mainType != newValue) {
        _mainType = newValue!;
        _pointTypes = PointType.values.where(_isOfMainType);
        _pointType = _pointTypes.first;
      }
    });
  }

  void _onChangedPointType(PointType? newValue) {
    setState(() {
      _pointType = newValue!;
    });
  }

  bool _isOfMainType(PointType type) => type.mainType == _mainType;

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Adding a ${_pointType.subType}...'),
        ),
      );
      ref
          .read(safetyServiceProvider.notifier)
          .addCustomPoint(
            Point(
              name: _titleController.text,
              description: _descriptionController.text,
              type: _pointType,
              latitude: widget.latLng.latitude,
              longitude: widget.latLng.longitude,
            ),
          )
          .then((_) {
        GoRouter.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong...'),
          ),
        );
      });
    }
  }
}
