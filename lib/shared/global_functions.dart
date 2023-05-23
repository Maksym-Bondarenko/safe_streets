import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// Collection of global functions, that are used across the application

// change default google-marker-icon to custom one
Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
}