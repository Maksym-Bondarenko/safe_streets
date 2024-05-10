import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/services/position.dart';

part 'places.g.dart';

const _baseUrl = 'places.googleapis.com';
const _nearbySearchRadius = 20000.0;
final _headers = {
  'Content-Type': 'application/json',
  'X-Goog-Api-Key': dotenv.env['GOOGLE_MAPS_API_KEY']!,
};
final _headersWithFieldMask = {
  ..._headers,
  'X-Goog-FieldMask': [
    'places.displayName.text',
    'places.location',
  ].join(','),
};

@Riverpod(keepAlive: true)
class PlacesService extends _$PlacesService {
  @override
  void build() {}

  Future<List<Place>> searchByText(
    String query,
  ) async {
    final data = jsonEncode({"textQuery": query});
    final uri = Uri.https(_baseUrl, 'v1/places:searchText');
    final response = await http.post(uri, headers: _headersWithFieldMask, body: data);
    return PlacesResponse.fromJson(jsonDecode(response.body)).places;
  }

  Future<List<Place>> searchByType({
    required PlaceType type,
    required double latitude,
    required double longitude,
  }) async {
    final data = jsonEncode({
      "includedTypes": [type],
      "locationRestriction": {
        "circle": {
          "center": {"latitude": latitude, "longitude": longitude},
          "radius": _nearbySearchRadius,
        },
      },
    });
    final uri = Uri.https(_baseUrl, 'v1/places:searchNearby');
    final response = await http.post(uri, headers: _headersWithFieldMask, body: data);
    return PlacesResponse.fromJson(jsonDecode(response.body)).places;
  }

  // TODO maybe replace by Places API
  Future<List<Placemark>> searchByLatLng(double latitude, double longitude) async {
    final response = await GeocodingPlatform.instance.placemarkFromCoordinates(latitude, longitude);
    return response;
  }

  Future<List<Suggestion>> autocomplete(String query) async {
    if (query.isEmpty) {
      print('## p - searchForQuery --------- EMPTY');
      return [];
    } else {
      print('## p - searchForQuery --------- $query');
      final Position(:latitude, :longitude) = await ref.read(positionProvider.future);
      final data = jsonEncode({
        "input": query,
        "includeQueryPredictions": true,
        "locationBias": {
          "circle": {
            "center": {"latitude": latitude, "longitude": longitude},
          },
        },
      });
      final uri = Uri.https(_baseUrl, 'v1/places:autocomplete');
      final response = await http.post(uri, headers: _headers, body: data);
      return AutocompleteResponse.fromJson(jsonDecode(response.body)).suggestions;
    }
  }
}
