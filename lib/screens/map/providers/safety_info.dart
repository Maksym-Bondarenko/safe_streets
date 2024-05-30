import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe_streets/models/safety_info.dart';
import 'package:safe_streets/services/safety.dart';

part 'safety_info.g.dart';

@riverpod
Future<SafetyInfo> safetyInfo(SafetyInfoRef ref) async {
  // TODO implement info based on selected position
  final (latitude, longitude) = (1.0, 1.0);
  final safetyInfo = ref.read(safetyServiceProvider.notifier).getSafetyInfoByLatLng(latitude, longitude);
  return safetyInfo;
}
