import 'dart:math';

import 'package:geolocator/geolocator.dart';

import 'package:safe_streets/models/safety_info.dart';

class SafetyInfoService {
  static final SafetyInfoService _singleton = SafetyInfoService._internal();

  factory SafetyInfoService() {
    return _singleton;
  }

  SafetyInfoService._internal();

  Future<SafetyInfo> getSafetyInformation(Position position) {
    final rating = Random().nextDouble() * 4 + 1;
    const description =
        'A lot of pickpocketing happens in this area. Make sure to keep an eye on your belongings.';
    final safetyInfo = SafetyInfo(rating: rating, description: description);
    return Future.value(safetyInfo);
  }
}
