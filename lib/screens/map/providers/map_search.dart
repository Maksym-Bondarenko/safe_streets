import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/screens/map/providers/map_controller.dart';
import 'package:safe_streets/screens/map/providers/selected_place.dart';
import 'package:safe_streets/services/places.dart';
import 'package:safe_streets/utils/map.dart';

part 'map_search.g.dart';

const _defaultMaxNumOfTextSearchResults = 10;

@riverpod
class MapSearchResults extends _$MapSearchResults {
  @override
  FutureOr<List<Place>> build() {
    return [];
  }

  Future<void> searchByQuery(
    String query, {
    int? pageSize,
  }) async {
    final mapControllerNotifier = ref.read(mapControllerProvider.notifier);
    final selectedPlaceNotifier = ref.read(selectedPlaceProvider.notifier);
    final results = await ref.read(placesServiceProvider.notifier).searchByText(
          query,
          pageSize: pageSize ?? _defaultMaxNumOfTextSearchResults,
        );
    if (results.length == 1) {
      selectedPlaceNotifier.set(results.first);
      mapControllerNotifier.centerOnSelectedPlace();
    } else if (results.length > 1) {
      final bounds = getLatLngBoundsOfPlaces(results);
      mapControllerNotifier.centerOnBounds(bounds);
      selectedPlaceNotifier.clear();
    }
    state = AsyncData(results);
  }

  void set(Place place) {
    state = AsyncData([place]);
  }

  void clear() {
    if (state.hasValue && state.value!.isNotEmpty) {
      ref.invalidateSelf();
    }
  }
}

@Riverpod(keepAlive: true)
Future<List<Suggestion>> mapSearchAutocomplete(MapSearchAutocompleteRef ref, String query) async {
  return await ref.read(placesServiceProvider.notifier).autocomplete(query);
}
