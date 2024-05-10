import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/services/places.dart';

part 'map_search.g.dart';

@riverpod
class MapSearchQuery extends _$MapSearchQuery {
  @override
  String build() => '';
}

@riverpod
Future<List<Suggestion>> mapSearchAutocomplete(MapSearchAutocompleteRef ref) async {
  final query = ref.watch(mapSearchQueryProvider);
  return await ref.read(placesServiceProvider.notifier).autocomplete(query);
}
