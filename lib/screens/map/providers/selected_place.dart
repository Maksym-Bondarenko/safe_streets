import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/screens/map/providers/map_search.dart';
import 'package:safe_streets/services/position.dart';
import 'package:safe_streets/services/places.dart';

part 'selected_place.g.dart';

@riverpod
class SelectedPlace extends _$SelectedPlace {
  @override
  Future<Place> build() async {
    // TODO test moving location // also during selection
    final Position(:latitude, :longitude) = await ref.watch(positionProvider.future);
    final places = await ref.read(placesServiceProvider.notifier).searchByLatLng(latitude, longitude);
    final place = places.firstOrNull;
    final displayText = place?.subLocality ?? place?.locality;
    return Place(
        location: Location(
          latitude: latitude,
          longitude: longitude,
        ),
        displayName: displayText != null ? TextData(text: displayText) : null);
  }

  Future<void> setBySuggestion(Suggestion suggestion) async {
    await ref.read(mapSearchResultsProvider.notifier).searchByQuery(suggestion.text.text, pageSize: 1);
  }

  void set(Place place) {
    state = AsyncData(place);
  }

  void clear() => ref.invalidateSelf();
}

@riverpod
Future<String?> selectedPlaceName(SelectedPlaceNameRef ref) async {
  final place = await ref.watch(selectedPlaceProvider.future);
  return place.displayName?.text;
}
