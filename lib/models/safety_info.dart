import 'package:flutter/material.dart';
import 'package:safe_streets/utils/safety_info.dart';

class SafetyInfo {
  final double rating;
  final String label;
  final String description;
  final Color color;

  SafetyInfo({
    required this.rating,
    required this.description,
  })  : label = getSafetyLabel(rating),
        color = getSafetyColor(rating);
}
