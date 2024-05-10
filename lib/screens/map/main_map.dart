import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe_streets/screens/map/components/base_map.dart';
import 'package:safe_streets/screens/map/components/map_control_buttons.dart';
import 'package:safe_streets/screens/map/components/map_filter_buttons.dart';
import 'package:safe_streets/screens/map/components/map_search_bar.dart';
import 'package:safe_streets/screens/map/components/safety_info_sheet.dart';
import 'package:safe_streets/screens/map/components/sos_menu.dart';

/// Main Map Screen with the FilterMarkers-Map, including 3 types of Points
class MainMapScreen extends ConsumerWidget {
  const MainMapScreen({super.key});

  @override
  Widget build(context, WidgetRef ref) {
    final screen = MediaQuery.of(context).size;
    final marginHorizontal = screen.width * 0.04;
    final marginTop = screen.height * 0.1;
    final marginBottom = screen.height * 0.2;
    return Stack(
      alignment: Alignment.center,
      children: [
        const BaseMap(),
        Positioned(
          left: marginHorizontal,
          right: marginHorizontal,
          top: marginHorizontal,
          child: const MapSearchBar(),
        ),
        Positioned(
          top: marginTop,
          child: MapFilterButtons(),
        ),
        Positioned(
          bottom: marginBottom,
          left: marginHorizontal,
          child: const SOSMenu(),
        ),
        Positioned(
          bottom: marginBottom,
          right: marginHorizontal,
          child: const MapControlButtons(),
        ),
        const SafetyInfoSheet(),
      ],
    );
  }
}
