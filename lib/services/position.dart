import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position.g.dart';

const _minLocationTreshholdInMeters = 10;
const _locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: _minLocationTreshholdInMeters,
);

@riverpod
Stream<Position> position(PositionRef ref) async* {
  yield* Geolocator.getPositionStream(locationSettings: _locationSettings);
}
