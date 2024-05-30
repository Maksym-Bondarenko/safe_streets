import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:safe_streets/utils/safety_info.dart';

part 'safety_info.freezed.dart';
part 'safety_info.g.dart';

@freezed
class SafetyInfo with _$SafetyInfo {
  const SafetyInfo._();

  const factory SafetyInfo({
    required double rating,
    required String description,
  }) = _SafetyInfo;

  String get label => getSafetyLabel(rating);
  Color get color => getSafetyColor(rating);

  factory SafetyInfo.fromJson(Map<String, dynamic> json) =>
      _$SafetyInfoFromJson(json);
}
