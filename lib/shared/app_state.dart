import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// AppState is a state management solution using Provider to store some
/// variables globally and make them accessible to all pages that need them
/// you need to wrap the parent-element with the 'ChangeNotifierProvider'
/// and use in children 'Provider.of' method to retrieve the variables
class AppState extends ChangeNotifier {
  // By using the provider package, the MapControllerProvider class acts
  // as a centralized place to store and access the Google Maps controller.
  GoogleMapController? _controller;

  GoogleMapController? get controller => _controller;

  set controller(GoogleMapController? controller) {
    _controller = controller;
    notifyListeners();
  }

  // currentIndex shows the currently active page on the bottom-bar
  // navigation menu to enable the navigation across app with one click
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
