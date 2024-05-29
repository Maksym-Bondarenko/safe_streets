import 'dart:math' show Random;

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/models/point.dart';
import 'package:safe_streets/models/safety_info.dart';
import 'package:safe_streets/services/places.dart';
import 'package:safe_streets/services/position.dart';

part 'safety.g.dart';

// const _baseUrl = 'http://34.159.7.34:8080';

@Riverpod(keepAlive: true)
class SafetyService extends _$SafetyService {
  @override
  Future<List<Point>> build() async {
    final policeStationPoints = await _getPoliceStationPoints();
    final customPoints = await _getCustomPoints();
    return [...policeStationPoints, ...customPoints];
  }

  Future<List<Point>> _getPoliceStationPoints() async {
    final Position(:latitude, :longitude) = await ref.read(positionProvider.future);
    final places = await ref.read(placesServiceProvider.notifier).searchByType(
          latitude: latitude,
          longitude: longitude,
          type: PlaceType.police,
        );
    return places
        .map((place) => Point(
              name: place.displayName?.text ?? '',
              latitude: place.location.latitude,
              longitude: place.location.longitude,
              type: SafePointType.police,
            ))
        .toList();
  }

  // TODO implement fetching custom points from backend instead of returning global list variable
  Future<List<Point>> _getCustomPoints() async {
    return [];

    // final response = await http.get(Uri.parse("$_baseUrl/get/all_places"));
    // final pointsJson = jsonDecode(response.body) as List<Map<String, dynamic>>;
    // return pointsJson.map((point) => Point.fromJson(point)).toList();
  }

  // TODO implement saving custom points to backend instead of adding to global list variable
  Future<void> addCustomPoint(Point point) async {
    final previousState = await future;
    state = AsyncData([...previousState, point]);

    //   final auth = FirebaseAuth.instance;
    //   final user = auth.currentUser;
    //   final userId = user?.uid ?? 'null';

    //   final Map<String, dynamic> userBody = {
    //     "firebase_id": userId,
    //     "full_name": user?.email ?? 'null',
    //     "email": user?.displayName ?? 'null',
    //   };

    //   final Map<String, dynamic> placeBody = {
    //     "firebase_user_id": userId,
    //     "title": point.name,
    //     "main_type": point.type.mainType,
    //     "sub_type": point.type.subType,
    //     "comment": point.description,
    //     "lat": point.latitude,
    //     "long": point.longitude,
    //   };

    //   // TODO: move all constants (urls) into the separate config-files
    //   try {
    //     final response = await http.get(
    //       Uri.parse("$_baseUrl/get/users?firebase_id=$userId"),
    //     );

    //     if (response.statusCode == 200 && response.body == "[]\n") {
    //       await http.post(
    //         Uri.parse("$_baseUrl/add/user"),
    //         headers: {"Content-Type": "application/json"},
    //         body: json.encode(userBody),
    //       );
    //     }

    //     await http.post(
    //       Uri.parse("$_baseUrl/add/place"),
    //       headers: {"Content-Type": "application/json"},
    //       body: json.encode(placeBody),
    //     );

    //     // Clears the cache and refetches custom points from server
    //     ref.invalidate(customPointsProvider);
    //   } catch (e) {
    //     print(e);
    //   }
  }

  // TODO implement info from backend instead of this random mock
  Future<SafetyInfo> getSafetyInfoByLatLng(double latitude, double longitude) async {
    final rating = Random().nextDouble() * 4 + 1;
    const description = 'A lot of pickpocketing happens in this area. Make sure to keep an eye on your belongings.';
    final safetyInfo = SafetyInfo(rating: rating, description: description);
    return Future.value(safetyInfo);
  }
}
