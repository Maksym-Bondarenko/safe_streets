import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

Future<Uint8List?> getBytesFromAsset(String path, num width) async {
  final data = await rootBundle.load(path);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width.toInt());
  final frameInfo = await codec.getNextFrame();
  final byteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  return byteData?.buffer.asUint8List();
}
