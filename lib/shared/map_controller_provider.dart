import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// By using the provider package, the MapControllerProvider class acts
/// as a centralized place to store and access the Google Maps controller.
class MapControllerProvider extends ChangeNotifier {
  GoogleMapController? _controller;

  GoogleMapController? get controller => _controller;

  set controller(GoogleMapController? controller) {
    _controller = controller;
    notifyListeners();
  }
}
