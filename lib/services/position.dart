import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position.g.dart';

@riverpod
Stream<Position> position(PositionRef ref) => Geolocator.getPositionStream();
