import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/services/position.dart';
import 'package:safe_streets/services/places.dart';

part 'selected_place.g.dart';

@riverpod
Future<String?> selectedPlaceName(SelectedPlaceNameRef ref) async {
  // TODO get by selection instead of current position
  final Position(:latitude, :longitude) = await ref.watch(positionProvider.future);
  final places = await ref.read(placesServiceProvider.notifier).searchByLatLng(latitude, longitude);
  return places.firstOrNull?.subLocality ?? places.firstOrNull?.locality;
}
