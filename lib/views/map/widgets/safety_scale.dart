import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/utils/safety_info.dart';

class SafetyScale extends StatelessWidget {
  final double _rating;
  final Color _color;

  SafetyScale({Key? key, required double rating})
      : _rating = rating,
        _color = getSafetyColor(rating),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: kSafetyScale,
          decoration: BoxDecoration(
            color: kGrey,
            borderRadius: BorderRadius.circular(kSpacingM),
          ),
        ),
        FractionallySizedBox(
          widthFactor: double.parse(_rating.toStringAsFixed(1)) / 5,
          child: Container(
            height: kSafetyScale,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(kSpacingM),
            ),
          ),
        ),
      ],
    );
  }
}
